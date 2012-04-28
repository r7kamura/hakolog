class Blog < ActiveRecord::Base
  attr_accessible :username, :dropbox_id, :dropbox_session

  has_many :entries

  %w[username dropbox_session dropbox_id].each do |attr|
    validates attr, :uniqueness => true, :presence => true
  end

  def title
    super || username
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
    response["entries"].each do |info|
      sync_entry_by_delta(info)
    end
    self.version = response["cursor"]
    self.save

    sync_with_dropbox if response[:has_more]
  end

  private

  def sync_entry_by_delta(delta)
    path, metadata = delta

    if metadata.nil?
      # path was deleted
      Entry.find_by_title(path).try(:destroy)

    elsif !metadata["is_dir"] && path =~ /\.md$/
      # path was edited or created
      modified_at = metadata["modified"]
      entry = Entry.find_or_initialize_by_blog_id_and_title(self.id, path)
      if (entry.updated_at || Time.local(0)) < modified_at
        entry.body = client.get_file(path).force_encoding("utf-8")
        entry.save
      end
    end
  end

  # get delta metadata using Dropbox delta API
  def get_delta
    client.delta(self.version)
  end
end
