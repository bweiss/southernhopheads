class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [ :admin ]

  def index
    @articles = Article.published.order("updated_at DESC").limit(6)
    @articles_and_events = find_featured_articles_and_events(:order => "updated_at DESC", :limit => 6)
  end

  def about
  end
  
  def admin
    authorize! :manage, User
    @user_count = User.count
    @article_count = Article.published.count
    @comment_count = Comment.count
    @new_users = User.order('created_at DESC').limit(4)
    @new_comments = Comment.order('created_at DESC').limit(4)
    @unconfirmed_users = User.where(:confirmed_at => [nil, false])
  end

  private

    #
    # Fetch the most recent articles and events, sorted and limited together as one resource.
    # This returns an array of hashes with each array element representing one row of returned data.
    #
    def find_featured_articles_and_events(options = { :order => nil, :limit => nil })
      results = Array.new
      cols = [:id, :title, :content, :user_id, :start_at, :end_at, :location, :allow_comments, :featured, :published, :created_at, :updated_at]

      query  = "(SELECT #{cols.join(', ')}, 'article' AS type"
      query << " FROM articles WHERE published = 1 AND featured = 1)"
      query << " UNION"
      query << " (SELECT #{cols.join(', ')}, 'event' AS type"
      query << " FROM events WHERE published = 1 AND featured = 1)"
      query << " ORDER BY #{order}" unless options[:order].nil?
      query << " LIMIT #{limit}" unless options[:limit].nil?

      rows = ActiveRecord::Base.connection.execute(query)

      rows.each do |row|
        results.push(Hash[*cols.zip(row).flatten])
      end

      return results
    end
end
