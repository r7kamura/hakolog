class Blog < ActiveRecord::Base
  attr_accessible :username, :dropbox_id, :dropbox_session

  validates :username, :uniqueness => true
  validates :dropbox_session, :uniqueness => true
end
