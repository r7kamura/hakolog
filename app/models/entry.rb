require "tempfile"

class Entry < ActiveRecord::Base
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

  attr_accessible :blog_id, :body, :extension, :path, :modified_at

  belongs_to :blog

  scope :search, lambda { |query|
    where("path like ? or body like ?", "%#{query}%", "%#{query}%")
  }

  validates :path,
    :presence   => true,
    :uniqueness => { :scope => :blog_id },
    :format     => {
      :with => /#{Regexp.escape(BASE_PATH)}.+#{Regexp.escape(DEFAULT_EXT)}/
    }

  before_save :downcase_path
  before_save :add_modified_at
  before_update :update_blog_modified_at
  before_destroy :file_delete

  paginates_per 10

  # overwrite
  def self.create(attributes = nil, options = {}, &block)
    if title = attributes.delete(:title)
      attributes[:path] = fullpath(title)
    end
    super
  end

  def self.parse(body)
    parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MARKDOWN_OPTION)
    parser.render(body)
  end

  def self.find_by_title(title)
    find_by_path(fullpath(title))
  end

  def self.find_by_blog_id_and_title(blog_id, title)
    where(
      :blog_id => blog_id,
      :path    => fullpath(title)
    ).first
  end

  def self.create_by_controller(params, blog)
    entry = create(
      :blog_id => blog.id,
      :title   => params[:entry][:title],
      :body    => params[:entry][:body]
    )
    entry.post
    entry
  end

  def self.initialize_with_title(args)
    new(
      :blog_id => args[:blog_id],
      :body    => args[:body],
      :path    => fullpath(args.delete(:title))
    )
  end

  # overwrite
  def update_attributes(attributes)
    if title = attributes.delete(:title)
      attributes[:path] = self.class.fullpath(title)
    end

    before = path
    super
    move(before, path) if before != path
    post(true)
  end

  def update_by_controller(params)
    update_attributes(
      :title => params[:entry][:title],
      :body  => params[:entry][:body]
    )
  end

  def title
    path && path.gsub(/^#{BASE_PATH}/, "").gsub(/#{DEFAULT_EXT}$/, "")
  end

  def camelized_title
    title.gsub(/[A-Za-z]+/) { |lowercase| lowercase.camelize }
  end

  def parsed_body
    self.class.parse(body).html_safe
  end

  def can_overwrite?(modified_at)
    self.updated_at.nil? || self.updated_at < modified_at
  end

  def file_delete
    if blog = self.blog
      blog.client.file_delete(self.path)
    end
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
    self.blog.update_attributes(:modified_at => self.modified_at)
  end

  def post(overwrite = true)
    temp = Tempfile.new("")
    temp.write(body)
    temp.close
    open(temp.path) { |file|
      blog.client.put_file(path, file, overwrite)
    }
  end

  # move file on Dropbox
  def move(old_path, new_path)
    blog.client.file_move(old_path, new_path)
  end

  def to_param
    title
  end

  def self.fullpath(title)
    BASE_PATH + title + DEFAULT_EXT
  end
end
