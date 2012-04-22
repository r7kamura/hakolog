class Blog < ActiveRecord::Base
  attr_accessible :edited_at, :syunced_at, :title, :username
end
