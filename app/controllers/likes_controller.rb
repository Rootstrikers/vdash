class LikesController < ApplicationController
  before_filter :require_user
  before_filter :get_item, only: [:create]

  def create
    current_user.toggle_like(@item)

    render json: { id: @item.id, itemKlass: @item.class.name, like_count: @item.likes.count, liked: current_user.liked?(@item) }
  end

  private

  def get_item
    @item = params[:item_klass].constantize.find(params[:item_id])
  end

end
