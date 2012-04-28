class Entry < ActiveRecord::Base
  attr_accessible :blog_id, :body, :extension, :path

  belongs_to :blog

  BASE_PATH = "/entries/"

  def self.create_with_path(args)
    create args.merge(:path => BASE_PATH + args.delete(:path))
  end

  def title
    path && path.split(BASE_PATH, 2).last
  end

  def can_overwrite?(modified_at)
    self.updated_at.nil? || self.updated_at < modified_at
  end
end
