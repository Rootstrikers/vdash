class RemoteLinksController < ApplicationController
  before_filter :require_user

  def show
    render json: RemoteLink.new(params[:url]).as_json
  end

end