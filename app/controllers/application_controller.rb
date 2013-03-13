class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end

  def require_user
    return if current_user
    session[:after_signin_url] = request.fullpath
    redirect_to '/signin'
  end

  def require_admin
    redirect_to root_url, alert: 'You must be an admin to access this area.' unless current_user.try(:admin?)
  end

  helper_method :current_user
end
