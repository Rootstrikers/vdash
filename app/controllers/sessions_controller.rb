class SessionsController < ApplicationController
	def create
		user = User.from_omniauth(env["omniauth.auth"])
		session[:user_id] = user.id
		redirect_to (session[:after_signin_url] || root_url), notice: "Hey there, #{user.name}!"
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_url, notice: "See you later!"
	end

	def failure
		redirect_to root_url, notice: "Something went horribly wrong..."
	end
end