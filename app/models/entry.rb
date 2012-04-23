class Entry < ActiveRecord::Base
  attr_accessible :blog_id, :body, :extension, :title

  belongs_to :blog
end
