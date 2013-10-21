class CommentsController < ApplicationController
  before_filter :authenticate_user!, :only => [ :new, :create, :edit, :update, :destroy ]
  before_filter :find_commentable

  def index
    @comments = @commentable.comments
  end

  def create
    authorize! :create, Comment, :message => 'Not authorized to create comments.'
    if @commentable.allow_comments
      @comment = @commentable.comments.build(params[:comment])
      current_user.comments << @comment
      if @comment.save
        @recipients = find_users_for_comment_notify(@commentable)
        if !@recipients.empty?
          @recipients.each do |u|
            UserMailer.email_comment(u, @comment).deliver
          end
        end
        flash[:notice] = "Successfully saved comment."
        redirect_to @commentable
      else
        render :action => 'new'
      end
    else
      flash[:notice] = "Comments disabled for this object."
      redirect_to @commentable
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize! :edit, @comment, :message => 'Not authorized to edit this comment.'
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment, :message => 'Not authorized to update this comment.'
    @comment.assign_attributes(params[:comment])
    if @comment.save
      flash[:notice] = "Comment has been updated."
      redirect_to @comment.commentable
    else
      render :action => 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    authorize! :destroy, @comment, :message => 'Not authorized to destroy this comment.'
    if @comment.destroy
      flash[:notice] = "Comment has been deleted."
      redirect_to @commentable
    else
      flash[:error] = "Error deleting comment."
      redirect_to @commentable
    end
  end

  private

    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @commentable = $1.classify.constantize.find(value)
          return @commentable
        end
      end
      nil
    end

    def find_users_for_comment_notify(commentable)
      opted_in_users = User.find_users_to_email_new_comments.pluck(:id)
      opted_in_users.delete(current_user.id)
      involved_users = Array.new(commentable.user_id) + commentable.comments.pluck(:user_id).uniq
      user_ids = involved_users.select { |x| opted_in_users.include?(x) }
      @users = User.find(user_ids)
      return @users
    end
end
