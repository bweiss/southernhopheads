class PostsController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy ]

  def new
    authorize! :new, Post, :message => 'You are not authorized to make new posts.'
    @forum = Forum.find(params[:forum_id])
    @post = Post.new
  end

  def create
    authorize! :create, Post, :message => 'You are not authorized to create posts.'
    @forum = Forum.find(params[:forum_id])
    @post = @forum.posts.build(params[:post])
    current_user.posts << @post
    if @post.save
      flash[:notice] = 'Post created. Thank you.'
      redirect_to @post
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post, :message => 'You are not authorized to edit posts.'
  end

  def update
    @post = Post.find(params[:id])
    authorize! :update, @post, :message => 'You are not authorized to update posts.'
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post has been updated.'
      redirect_to @post
    else
      render :action => 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize! :destroy, @post, :message => 'Not authorized to delete posts.'
    @post.destroy
    flash[:notice] = 'Post has been deleted.'
    redirect_to forums_path
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.paginate(:page => params[:page], :per_page => 10)
  end
end
