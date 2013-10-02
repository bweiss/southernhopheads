class AddEmailPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_new_events, :boolean
    add_column :users, :email_event_reminders, :boolean
    add_column :users, :email_new_comments, :boolean
  end
end
