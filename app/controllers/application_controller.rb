class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user, :set_notice, :ensure_not_banned, :set_link, :set_content

  private

  def set_current_user
    Thread.current[:current_user] = current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    return if current_user
    session[:after_signin_url] = request.fullpath if request.get?
    redirect_to signin_url, alert: 'Please sign in.'
  end

  def require_admin
    redirect_to signin_url, alert: 'You must be an admin to access this page.' unless current_user.try(:admin?)
  end

  def set_notice
    @site_wide_notice = Notice.active
  end

  def ensure_not_banned
    redirect_to root_url, flash: { error: "You are banned." } if current_user.try(:banned?)
  end

  def set_link
    @link = Link.new
  end

  def set_content
    @content = Content.new
  end

  helper_method :current_user
end
