class AddExtrasToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :whats_brewing, :text
  end
end
