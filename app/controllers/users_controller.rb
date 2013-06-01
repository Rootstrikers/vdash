class UsersController < ApplicationController
  before_filter :require_user
  before_filter :get_user
  before_filter :ensure_user_is_self, only: [:edit, :update]

  def show
    @links    = @user.links
    @contents = @user.contents
  end

  def edit; end

  def update
    if @user.update_attributes(params[:user])
      redirect_to user_url(@user), flash: { success: 'Profile successfully updated.' }
    else
      render :edit
    end
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

  def ensure_user_is_self
    if @user != current_user
      redirect_to root_url, flash: { error: 'You can only edit yourself, buddy.' }
    end
  end
end
