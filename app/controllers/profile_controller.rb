class ProfileController < ApplicationController
  before_filter :authenticate_user!, :only => [ :edit, :update ]

  def edit
    @user = current_user
    authorize! :edit, @user, :message => 'Not authorized to perform this action.'
  end

  def update
    @user = current_user
    authorize! :update, @user, :message => 'Not authorized to perform this action.'    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated successfully."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end
end
