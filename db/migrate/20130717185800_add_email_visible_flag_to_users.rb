class AddEmailVisibleFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_visible, :boolean
  end
end
