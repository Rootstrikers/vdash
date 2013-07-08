class SessionsController < ApplicationController
  def create
    next_url = session.delete(:after_signin_url) || root_url

    # TODO: Move this to a service?
    if current_user
      if current_user.add_linked_account(env['omniauth.auth'])
        flash_text = 'You have linked a new social media account!'
        next_url   = linked_accounts_url
      else
        flash_text = 'You are already signed in with that account!'
      end
    else
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      flash_text = "Hey there, #{view_context.link_to user.name, user}! Let's get to work.".html_safe
    end

    redirect_to next_url, notice: flash_text
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "See you later!"
  end

  def failure
    redirect_to root_url, notice: "Something went horribly wrong..."
  end
end
