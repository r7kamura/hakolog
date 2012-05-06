class Blog < ActiveRecord::Base
  attr_accessible :username, :dropbox_id, :dropbox_session, :synced_at, :modified_at

  has_many :entries, :order => "modified_at DESC"
  has_many :random_entries, :class_name => :Entry,
    :order => connection.adapter_name == "Mysql2" ? "RAND()" : "RANDOM()"

  %w[username dropbox_session dropbox_id].each do |attr|
    validates attr, :uniqueness => true, :presence => true
  end
  validates :username, :format => { :with => /^[a-z0-9]{1,12}$/ }

  after_create :create_default_files

  paginates_per 10

  def title
    super || username
  end

  def entry_date_count
    self.entries.pluck(:modified_at).map(&:beginning_of_day).uniq.size
  end

  # return <#DropboxClient> activated by self.dropbox_session
  def client
    @client ||= DropboxClient.new(
      DropboxSession.deserialize(self.dropbox_session),
      :app_folder
    )
  end

  # update by Dropbox delta API & save latest version key
  def sync_with_dropbox
    response = get_delta
    response["entries"].each { |info| sync_entry_by_delta(info) }
    update_attributes(
      :vertion   => response["cursor"],
      :synced_at => Time.now
    )
    sync_with_dropbox if response["has_more"]
  rescue DropboxAuthError
    puts "DropboxAuthError in Blog#sync_with_dropbox: #{self.username}"
  end

  def to_param
    username
  end

  private

  def sync_entry_by_delta(delta)
    path, metadata = delta

    # path was deleted
    if metadata.nil?
      Entry.find_by_path(path).try(:destroy)

    # path was edited or created
    elsif !metadata["is_dir"] && path =~ /\.md$/
      modified_at = metadata["modified"]
      entry = Entry.find_or_initialize_by_blog_id_and_path(self.id, path)
      if entry.can_overwrite?(modified_at)
        entry.update_attributes(
          :body => client.get_file(path).force_encoding("utf-8")
        )
      end
    end
  end

  # get delta metadata using Dropbox delta API
  def get_delta
    client.delta(self.version)
  end

  def create_default_files
    Entry.create(
      :blog_id => id,
      :title   => "README",
      :body    => Rails.root.join("README.md").read,
    )
    sync_with_dropbox
  end
end
