class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.datetime :start_at
      t.datetime :end_at
      t.string :location
      t.boolean :allow_comments, :default => true
      t.boolean :featured, :default => false
      t.boolean :published, :default => false

      t.timestamps
    end

    add_index :events, :start_at
  end

  def down
    drop_table :events
  end
end
