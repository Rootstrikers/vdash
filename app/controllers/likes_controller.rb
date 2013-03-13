class LikesController < ApplicationController
  before_filter :require_user
  before_filter :get_item, only: [:create]

  def create
    # Overloading the create action like this is unfortunate.
    # TODO: Come up with something more elegant.
    if current_user.liked?(@item)
      current_user.likes.where(item_type: @item.class.name, item_id: @item.id).first.destroy
      redirect_to :back, flash: { success: 'Unliked.' }
    else
      @item.likes << Like.new(user: current_user)
      redirect_to :back, flash: { success: 'Liked!' }
    end
  end

  private

  def get_item
    @item = params[:item_klass].constantize.find(params[:item_id])
  end

end
