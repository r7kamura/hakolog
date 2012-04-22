class ChangeBlogColumnNameFromSyuncedAtToSyncedAt < ActiveRecord::Migration
  def up
    rename_column :blogs, :syunced_at, :synced_at
  end

  def down
    rename_column :blogs, :synced_at, :syunced_at
  end
end
