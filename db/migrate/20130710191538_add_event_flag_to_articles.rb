class AddEventFlagToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :event, :boolean
  end
end
