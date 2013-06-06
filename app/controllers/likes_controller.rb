class LikesController < ApplicationController
  before_filter :require_user
  before_filter :get_item, only: [:create]

  def create
    if current_user.clicked?(@item) or current_user == @item.user
      current_user.toggle_like(@item)
      status = :ok
    else
      status = :needs_click
    end

    render json: { id: @item.id, itemKlass: @item.class.name, like_count: @item.likes.count, liked: current_user.liked?(@item), status: status }
  end

  private

  def get_item
    @item = params[:item_klass].constantize.find(params[:item_id])
  end

end
