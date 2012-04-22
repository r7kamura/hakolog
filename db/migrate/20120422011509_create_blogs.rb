class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :username
      t.datetime :edited_at
      t.datetime :syunced_at

      t.timestamps
    end
  end
end
