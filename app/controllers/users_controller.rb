class UsersController < ApplicationController
  before_filter :require_user

  def show
    @user = User.includes(:links).find(params[:id])
  end
end
