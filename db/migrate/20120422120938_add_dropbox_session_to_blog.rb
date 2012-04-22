class AddDropboxSessionToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :dropbox_session, :string
  end
end
