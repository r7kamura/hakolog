class ChangeEntryBlogIdNotToAllowNull < ActiveRecord::Migration
  def up
    change_column :entries, :blog_id, :integer, :null => false
  end

  def down
    change_column :entries, :blog_id, :integer
  end
end
