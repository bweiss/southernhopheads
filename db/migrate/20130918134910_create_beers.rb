class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.text :description, :null => true, :default => nil
      t.integer :brewery_id
      t.decimal :abv, :precision => 5, :scale => 2, :null => true, :default => nil
      t.integer :srm, :null => true, :default => nil
      t.integer :ibu, :null => true, :default => nil
      t.string :style, :null => true, :default => nil
      t.boolean :featured, :default => false

      t.timestamps
    end
  end
end
