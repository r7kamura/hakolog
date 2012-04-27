class Blog < ActiveRecord::Base
  attr_accessible :username, :dropbox_id, :dropbox_session

  has_many :entries

  %w[username dropbox_session dropbox_id].each do |attr|
    validates attr, :uniqueness => true, :presence => true
  end

  def title
    super || username
  end

  # update by using Dropbox delta API & save latest version key
  def sync_with_dropbox
    delta = get_delta

    self.version = delta["cursor"]
    self.save
    delta["entries"].each do |entry_info|
      next if entry_info[1]["is_dir"]

      modified_at = entry_info[1]["modified"]
      title       = entry_info[0].split("/entires/", 2)[0]

      entry = Entry.find_or_initialize_by_title(title)
      if (entry.updated_at || Time.local(0)) < modified_at
        entry.body = client.get_file(title).force_encoding("utf-8")
        entry.save
      end
    end

    sync_with_dropbox if delta[:has_more]
  end

  # get delta metadata using Dropbox delta API
  def get_delta
    client.delta(self.version)
  end

  def client
    @client ||= DropboxClient.new(
      DropboxSession.deserialize(self.dropbox_session),
      :app_folder
    )
  end
end
