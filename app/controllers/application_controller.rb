class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user, :set_notice

  private

  def set_current_user
    Thread.current[:current_user] = current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    return if current_user
    session[:after_signin_url] = request.fullpath
    redirect_to signin_url, alert: 'Please sign in.'
  end

  def require_admin
    redirect_to signin_url, alert: 'You must be an admin to access this page.' unless current_user.try(:admin?)
  end

  def set_notice
    @site_wide_notice = Notice.active
  end

  helper_method :current_user
end
