class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.decimal :score, :precision => 3, :scale => 1
      t.text :content, :null => true, :default => nil
      t.integer :beer_id, :null => true, :default => nil
      t.integer :user_id, :null => true, :default => nil

      t.timestamps
    end
  end
end
