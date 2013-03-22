class TwitterContentsController < ApplicationController
  before_filter :require_user
  before_filter :get_link, except: [:index]
  before_filter :require_admin, only: [:index]
  before_filter :get_content, only: [:edit, :update, :destroy]

  def index
    @contents = TwitterContent.unposted.ordered
  end

  def new
    @content = @link.twitter_contents.new
  end

  def edit; end

  def create
    @content = current_user.twitter_contents.new(twitter_content_params)
    if @content.save
      redirect_to link_url(@link), flash: { success: 'Tweet submission created.' }
    else
      render :new
    end
  end

  def update
    if @content.update_attributes(twitter_content_params)
      redirect_to link_url(@link), flash: { success: 'Tweet submission updated.' }
    else
      render :edit
    end
  end

  def destroy
    @content.destroy
    redirect_to link_url(@link), flash: { success: 'Tweet submission deleted.' }
  end

  private
  def twitter_content_params
    params[:twitter_content].tap { |p| p[:link_id] = @link.id }
  end

  def get_link
    @link = Link.find(params[:link_id])
  end

  def get_content
    @content = current_user.twitter_contents.where(link_id: @link.id).find(params[:id])
  end
end
