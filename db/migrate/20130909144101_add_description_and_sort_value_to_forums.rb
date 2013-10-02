class AddDescriptionAndSortValueToForums < ActiveRecord::Migration
  def change
    add_column :forums, :description, :string
    add_column :forums, :sort_value, :integer
  end
end
