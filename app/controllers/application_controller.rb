class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  before_filter :prepare_for_mobile

  layout :which_layout

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  private

    def mobile_device?
      if session[:mobile_param]
        session[:mobile_param] == "1"
      else
        request.user_agent =~ /Mobile|webOS|Android/
      end
    end
    helper_method :mobile_device?

    def current_user_or_admin?(user)
      if user_signed_in?
        (user.has_role? :admin or user == current_user)
      else
        false
      end
    end
    helper_method :current_user_or_admin?

    def prepare_for_mobile
      session[:mobile_param] = params[:mobile] if params[:mobile]
    end

    def which_layout
      mobile_device? ? 'mobile' : 'application'
    end
end
