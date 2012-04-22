class AddDropboxIdToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :dropbox_id, :integer
  end
end
