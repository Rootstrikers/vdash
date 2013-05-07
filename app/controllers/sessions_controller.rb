class SessionsController < ApplicationController
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
end
