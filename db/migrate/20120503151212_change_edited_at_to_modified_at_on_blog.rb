class ChangeEditedAtToModifiedAtOnBlog < ActiveRecord::Migration
  def up
    rename_column :blogs, :edited_at, :modified_at
  end

  def down
    rename_column :blogs, :modified_at, :edited_at
  end
end
