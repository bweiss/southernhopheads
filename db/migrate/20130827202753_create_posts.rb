class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :forum_id
      t.integer :user_id
      t.boolean :sticky

      t.timestamps
    end
  end
end
