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

  before_save :downcase_path
  before_save :add_modified_at
  before_update :update_blog_modified_at
  after_destroy :file_delete

  def self.parse(body)
    parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MARKDOWN_OPTION)
    parser.render(body)
  end

  def self.create_with_title(args)
    obj = initialize_with_title(args)
    obj.save && obj
  end

  def self.initialize_with_title(args)
    new(
      :blog_id => args[:blog_id],
      :body    => args[:body],
      :path    => BASE_PATH + args.delete(:title) + DEFAULT_EXT
    )
  end

  def update_with_title(args)
    update_attributes(
      :body => args[:body],
      :path => BASE_PATH + args.delete(:title) + DEFAULT_EXT
    )
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
    puts "DropboxError in Entry#file_delete: #{self.path} does not exist."
  end

  def downcase_path
    self.path = self.path.downcase
  end

  def add_modified_at
    self.modified_at = Time.now
  end

  def update_blog_modified_at
    self.blog.update_attributes(:modified_at => Time.now)
  end
end
