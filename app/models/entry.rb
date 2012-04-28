class Entry < ActiveRecord::Base
  attr_accessible :blog_id, :body, :extension, :path, :modified_at

  belongs_to :blog

  BASE_PATH = "/entries/"
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

  def self.create_with_title(args)
    create args.merge(
      :path        => BASE_PATH + args.delete(:title),
      :modified_at => Time.now
    )
  end

  def title
    path && path.split(BASE_PATH, 2).last
  end

  def body
    parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MARKDOWN_OPTION)
    parser.render(super).html_safe
  end

  def can_overwrite?(modified_at)
    self.updated_at.nil? || self.updated_at < modified_at
  end
end
