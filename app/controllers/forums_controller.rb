class ForumsController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy ]

  def index
    @forums = Forum.order('sort_value ASC')
  end

  def new
    authorize! :new, Forum, :message => 'You are not authorized to make new forums.'
    @forum = Forum.new
  end

  def create
    authorize! :create, Forum, :message => 'You are not authorized to create forums.'
    @forum = Forum.new(params[:forum])
    if @forum.save
      flash[:notice] = 'Forum created. Thank you.'
      redirect_to @forum
    else
      render :action => 'new'
    end
  end

  def edit
    @forum = Forum.find(params[:id])
    authorize! :edit, @forum, :message => 'You are not authorized to edit forums.'
  end

  def update
    @forum = Forum.find(params[:id])
    authorize! :update, @forum, :message => 'You are not authorized to update forums.'
    if @forum.update_attributes(params[:forum])
      flash[:notice] = 'Forum has been updated.'
      redirect_to @forum
    else
      render :action => 'edit'
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    authorize! :destroy, @forum, :message => 'Not authorized to delete forums.'
    @forum.destroy
    flash[:notice] = 'Forum has been deleted.'
    redirect_to forum_path
  end

  def show
    @forum = Forum.find(params[:id])
    @stuck = @forum.posts.stuck.order('created_at ASC')
    @unstuck = @forum.posts.unstuck.order('created_at DESC')
    @posts = (@stuck + @unstuck).paginate(:page => params[:page], :per_page => 10)
  end
end
