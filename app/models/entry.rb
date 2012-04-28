class Entry < ActiveRecord::Base
  attr_accessible :blog_id, :body, :extension, :title

  belongs_to :blog

  def can_overwrite?(modified_at)
    (entry.updated_at || Time.local(0)) < modified_at
  end
end
