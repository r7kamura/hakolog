class Entry < ActiveRecord::Base
  attr_accessible :blog_id, :body, :extension, :path, :modified_at

  belongs_to :blog

  paginates_per 5

  DEFAULT_EXT = ".md"
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
    # SHOULD: use validation
    return if args[:title].blank?

    create args.merge(
      :path        => BASE_PATH + args.delete(:title) + DEFAULT_EXT,
      :modified_at => Time.now
    )
  end

  def title
    path && path.split(BASE_PATH, 2).last
    path && path.gsub(/^#{BASE_PATH}/, "").gsub(/#{DEFAULT_EXT}$/, "")
  end

  def body
    parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MARKDOWN_OPTION)
    parser.render(super).html_safe
  end

  def can_overwrite?(modified_at)
    self.updated_at.nil? || self.updated_at < modified_at
  end
end
