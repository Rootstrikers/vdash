class FacebookContentsController < ApplicationController
  before_filter :require_user
  before_filter :get_link, except: [:index]
  before_filter :get_content, only: [:edit, :update, :destroy]

  def new
    @content = @link.facebook_contents.new
  end

  def edit; end

  def create
    @content = current_user.facebook_contents.new(facebook_content_params)
    if @content.save
      redirect_to link_url(@link), flash: { success: 'Facebook post submission created.' }
    else
      render :new
    end
  end

  def update
    if @content.update_attributes(facebook_content_params)
      redirect_to link_url(@link), flash: { success: 'Facebook post submission updated.' }
    else
      render :edit
    end
  end

  def destroy
    @content.fake_delete
    redirect_to link_url(@link), flash: { success: 'Facebook post submission deleted.' }
  end

  private
  def facebook_content_params
    params[:facebook_content].tap { |p| p[:link_id] = @link.id }
  end

  def get_link
    @link = Link.find(params[:link_id])
  end

  def get_content
    @content = current_user.facebook_contents.where(link_id: @link.id).find(params[:id])
  end
end
