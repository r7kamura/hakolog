class AddVersionToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :version, :string
  end
end
