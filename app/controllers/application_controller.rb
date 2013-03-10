class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    # TODO: Fix this after authentication is done
    @current_user ||= User.first || User.create #User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to root_url, alert: 'You must be logged in to access this area.' unless current_user
  end

  def require_admin
    redirect_to root_url, alert: 'You must be an admin to access this area.' unless current_user.try(:admin?)
  end

  helper_method :current_user
end
