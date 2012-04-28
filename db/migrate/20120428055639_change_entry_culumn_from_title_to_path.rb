class ChangeEntryCulumnFromTitleToPath < ActiveRecord::Migration
  def up
    rename_column :entries, :title, :path
  end

  def down
    rename_column :entries, :path, :title
  end
end
