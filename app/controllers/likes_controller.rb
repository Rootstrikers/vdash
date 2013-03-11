class LikesController < ApplicationController
  before_filter :require_user, :get_item, :ensure_not_liked

  def create
    @item.likes << Like.new(user: current_user)
    redirect_to :back, flash: { success: 'Liked!' }
  end

  private
  def ensure_not_liked
    # TODO
  end

  def get_item
    @item = params[:item_klass].constantize.find(params[:item_id])
  end

end
