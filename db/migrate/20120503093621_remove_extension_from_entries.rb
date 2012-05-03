class RemoveExtensionFromEntries < ActiveRecord::Migration
  def up
    remove_column :entries, :extension
  end

  def down
    add_column :entries, :extension, :string
  end
end
