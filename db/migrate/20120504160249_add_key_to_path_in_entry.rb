class AddKeyToPathInEntry < ActiveRecord::Migration
  def up
    add_index :entries, :path
  end

  def down
    remove_index :entries, :column => :path
  end
end
