class LinksController < ApplicationController
  before_filter :require_user, except: [:index]
  before_filter :get_link, only: [:edit, :update]

  def index
    @links = Link.unposted.ordered.paginate(page: params[:page])
  end

  def show
    @link              = Link.find(params[:id])
    @twitter_contents  = @link.twitter_contents
    @facebook_contents = @link.facebook_contents
  end

  def new
    @link = Link.new
  end

  def edit; end

  def create
    @link = current_user.links.new(params[:link])
    if @link.save
      redirect_to link_url(@link), flash: { success: 'Link created.' }
    elsif @link.link_with_same_url.present?
      redirect_to link_url(@link.link_with_same_url), flash: { alert: 'Link has already been submitted!' }
    else
      render :new
    end
  end

  def update
    if @link.update_attributes(params[:link])
      redirect_to link_url(@link), flash: { success: 'Link updated.' }
    else
      render :edit
    end
  end

  def destroy
    link = current_user.links.find_by_id(params[:id])
    link = Link.find(params[:id]) if current_user.try(:admin) and link.nil?
    link.fake_delete
    redirect_to links_url, flash: { success: 'Link deleted.' }
  end

  private
  def get_link
    @link = current_user.links.find(params[:id])
  end

end
