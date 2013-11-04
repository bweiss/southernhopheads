class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [ :index, :destroy ]

  def index
    authorize! :index, User, :message => 'Not authorized to perform this action.'
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    authorize! :show, @user, :message => 'Not authorized to perform this action.'
  end
    
  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user, :message => 'Not authorized to perform this action.'
    unless @user == current_user
      @user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  def unsubscribe
    if @user = User.read_access_token(params[:signature])
      sign_in @user
      @user.update_attribute :email_new_events, false
      @user.update_attribute :email_event_reminders, false
      @user.update_attribute :email_new_comments, false
      redirect_to preferences_path, :notice => "You have been unsubscribed from all emails."
    else
      redirect_to root_path, :alert => "Invalid Link."
    end
  end
end