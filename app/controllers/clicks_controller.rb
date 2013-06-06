class ClicksController < ApplicationController
    before_filter :require_user, :get_item

  def create
    current_user.clicks << Click.new(item: @item) unless current_user.clicked?(@item)

    render json: {}
  end

  private
  def get_item
    @item = params[:item_klass].constantize.find(params[:item_id])
  end
end
