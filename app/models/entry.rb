class Entry < ActiveRecord::Base
  attr_accessible :blog_id, :body, :extension, :path, :modified_at

  belongs_to :blog

  scope :search, lambda { |query|
    where("path like ? or body like ?", "%#{query}%", "%#{query}%")
  }

  paginates_per 10

  DEFAULT_EXT     = ".md"
  BASE_PATH       = "/entries/"
  MARKDOWN_OPTION = {
    :autolink            => true,
    :fenced_code_blocks  => true,
    :lax_html_blocks     => true,
    :strikethrough       => true,
    :generate_toc        => true,
    :hard_wrap           => true,
    :tables              => true,
    :no_intra_emphasis   => true,
  }

  after_destroy :file_delete

  def self.parse(body)
    parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MARKDOWN_OPTION)
    parser.render(body)
  end

  def self.initialize_with_title(args)
    new args.merge(
      :path        => BASE_PATH + args.delete(:title) + DEFAULT_EXT,
      :modified_at => Time.now
    )
  end

  def self.create_with_title(args)
    obj = initialize_with_title(args)
    obj.save && obj
  end

  def update_with_title(args)
    self.body        = args[:body]
    self.path        = BASE_PATH + args.delete(:title) + DEFAULT_EXT
    self.modified_at = Time.now
    self.save
  end

  def title
    path && path.gsub(/^#{BASE_PATH}/, "").gsub(/#{DEFAULT_EXT}$/, "")
  end

  def parsed_body
    self.class.parse(body).html_safe
  end

  def can_overwrite?(modified_at)
    self.updated_at.nil? || self.updated_at < modified_at
  end

  def file_delete
    self.blog.client.file_delete(self.path)
  rescue DropboxError
    puts "Entry#file_delete: #{self.path} does not exist."
  end
end
