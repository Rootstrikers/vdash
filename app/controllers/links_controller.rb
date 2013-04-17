class LinksController < ApplicationController
  respond_to :js, :json, :html, :xml
  before_filter :require_user, except: [:index]
  before_filter :get_link_and_ensure_modifiable, only: [:edit, :update, :destroy]

  def index
    @links           = Link.unposted.ordered.includes(:contents).paginate(page: params[:page])
    @suggest_article = params[:suggest] == 'true'
  end

  def show
    @link     = Link.find(params[:id])
    @contents = @link.contents # TODO sort better. reddit algorithm?
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
    @link.fake_delete
    redirect_to links_url, flash: { success: 'Link deleted.' }
  end

  private
  def get_link_and_ensure_modifiable
    @link = Link.find(params[:id])
    redirect_to links_url, flash: { error: 'This link is not currently modifiable.' } unless @link.modifiable_by?(current_user)
  end

end
