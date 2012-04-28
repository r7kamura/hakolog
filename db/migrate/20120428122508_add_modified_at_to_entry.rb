class AddModifiedAtToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :modified_at, :datetime
  end
end
