class Entry < ActiveRecord::Base
  attr_accessible :blog_id, :body, :extension, :title

  belongs_to :blog

  def can_overwrite?(modified_at)
    entry.updated_at.nil? || entry.updated_at < modified_at
  end
end
