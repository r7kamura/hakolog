class Blog < ActiveRecord::Base
  attr_accessible :username, :dropbox_id, :dropbox_session

  validates :username, :uniqueness => true, :presence => true
  validates :dropbox_session, :uniqueness => true, :presence => true
  validates :dropbox_id, :uniqueness => true, :presence => true
end
