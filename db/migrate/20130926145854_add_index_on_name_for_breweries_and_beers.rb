class AddIndexOnNameForBreweriesAndBeers < ActiveRecord::Migration
  def change
    add_index :breweries, :name, :unique => true
    add_index :beers, :name
  end
end
