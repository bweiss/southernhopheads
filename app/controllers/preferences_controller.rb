class PreferencesController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
    authorize! :edit, @user, :message => 'Not authorized to perform this action.'
  end

  def update
    @user = current_user
    authorize! :update, @user, :message => 'Not authorized to perform this action.'
    if @user.update_attributes(params[:user])
      flash[:notice] = "Preferences updated successfully."
    else
      flash[:error] = "Error updating preferences."
    end
    redirect_to preferences_path
  end
end
