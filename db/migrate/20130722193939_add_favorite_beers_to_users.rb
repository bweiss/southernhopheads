class AddFavoriteBeersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorite_beers, :text
  end
end
