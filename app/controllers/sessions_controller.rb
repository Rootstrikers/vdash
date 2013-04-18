class SessionsController < ApplicationController
  before_filter :ensure_can_signup, only: [:create]

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    next_url = session.delete(:after_signin_url) || root_url
    redirect_to (next_url), notice: "Hey there, <a href='#{url_for(current_user)}'>#{user.name}</a>! Let's get to work.".html_safe
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "See you later!"
  end

  def failure
    redirect_to root_url, notice: "Something went horribly wrong..."
  end

  private
  def ensure_can_signup
    return if User.existing_user(env["omniauth.auth"]).present?
    redirect_to root_url, notice: "Sorry, but we're not open to public registrations quite yet!" unless session[:can_sign_up]
  end
end
