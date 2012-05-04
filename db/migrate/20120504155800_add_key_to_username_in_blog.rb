class AddKeyToUsernameInBlog < ActiveRecord::Migration
  def up
    add_index :blogs, :username
  end

  def down
    remove_index :blogs, :column => :username
  end
end
