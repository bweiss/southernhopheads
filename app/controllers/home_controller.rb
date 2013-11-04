class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [ :admin ]

  def index
    @articles = Article.published.order("created_at DESC").limit(6)
  end

  def about
  end
  
  def admin
    authorize! :manage, :all
    @user_count = User.count
    @article_count = Article.published.count
    @comment_count = Comment.count
    @new_users = User.order('created_at DESC').limit(4)
    @new_comments = Comment.order('created_at DESC').limit(4)
    @unconfirmed_users = User.where(:confirmed_at => [nil, false])
  end
end
