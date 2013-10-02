class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [ :admin ]

  def index
    @articles = Article.published.order("created_at DESC").limit(6)
  end

  def about
  end
  
  def admin
    authorize! :manage, :all
  end
end
