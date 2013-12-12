class AddNewEmailPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_about_articles, :boolean, :default => true
    add_column :users, :email_about_events, :boolean, :default => true
  end
end
