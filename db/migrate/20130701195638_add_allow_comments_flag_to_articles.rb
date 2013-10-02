class AddAllowCommentsFlagToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :allow_comments, :boolean
  end
end
