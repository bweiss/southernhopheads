class RemoveWebsiteFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :website
  end

  def down
    add_column :users, :website, :string
  end
end
