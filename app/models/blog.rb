class Blog < ActiveRecord::Base
  attr_accessible :username, :dropbox_id, :dropbox_session

  has_many :entries

  validates :username, :uniqueness => true, :presence => true
  validates :dropbox_session, :uniqueness => true, :presence => true
  validates :dropbox_id, :uniqueness => true, :presence => true

  def title
    super || username
  end
end
