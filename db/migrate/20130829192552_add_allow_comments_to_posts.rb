class AddAllowCommentsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :allow_comments, :boolean, :default => true
  end
end
