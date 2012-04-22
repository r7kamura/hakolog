class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :extension
      t.text :body
      t.integer :blog_id

      t.timestamps
    end
  end
end
