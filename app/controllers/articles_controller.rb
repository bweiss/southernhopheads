class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy, :queue, :publish, :email ]

  def index
    @articles = Article.published.order('updated_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def new
    authorize! :new, Article, :message => 'Not authorized to create articles.'
    @article = Article.new
  end

  def create
    authorize! :create, Article, :message => 'Not authorized to create articles.'
    @article = Article.new(params[:article])
    @article.user_id = current_user.id
    @article.end_at = @article.start_at if @article.end_at.nil?
    if @article.save
      flash[:notice] = 'Article created. Thank you!'
      redirect_to @article
    else
      render :action => 'new'
    end
  end

  def show
    if user_signed_in?
      if current_user.has_role?(:admin)
        @article = @commentable = Article.find(params[:id])
      else
        @article = @commentable = Article.published.find(params[:id])
      end
    else
      @article = @commentable = Article.published.find(params[:id])
    end
    @comments = @article.comments.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @article = Article.find(params[:id])
    authorize! :edit, @article, :message => 'Not authorized to edit articles.'
  end

  def update
    @article = Article.find(params[:id])
    authorize! :update, @article, :message => 'Not authorized to update articles.'
    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article has been updated.'
      redirect_to @article
    else
      render :action => 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    authorize! :destroy, @article, :message => 'Not authorized to delete articles.'
    @article.destroy
    flash[:notice] = 'Article has been deleted.'
    redirect_to root_path
  end

  def queue
    authorize! :queue, Article, :message => 'Not authorized to access article queue.'
    @articles = Article.unpublished.order('updated_at DESC')
  end

  def publish
    @article = Article.find(params[:id])
    authorize! :publish, @article, :message => 'Not authorized to publish this article.'
    @article.published = true
    if @article.save
      flash[:notice] = 'Article has been published.'
    else
      flash[:error] = 'There was an error publishing this article.'
    end
    redirect_to queue_path
  end

  def email
    @article = Article.find(params[:id])
    authorize! :email, @article, :message => 'Not authorized to email this article.'
    @recipients = User.find_users_to_email_new_events
    if @article.valid? and !@recipients.empty?
      @recipients.each do |u|
        UserMailer.email_article(u, @article).deliver
      end
      flash[:notice] = 'Your message has been sent! Thank you!'
      redirect_to @article
    else
      flash[:error] = 'Error. Email not sent.'
      redirect_to @article
    end
  end
end
