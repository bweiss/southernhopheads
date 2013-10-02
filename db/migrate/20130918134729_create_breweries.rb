class CreateBreweries < ActiveRecord::Migration
  def change
    create_table :breweries do |t|
      t.string :name
      t.text :description, :null => true, :default => nil
      t.string :location, :null => true, :default => nil
      t.string :website, :null => true, :default => nil

      t.timestamps
    end
  end
end
