module Feeds
  class FacebookPostsController < ApplicationController
    def index
      @posts = FacebookContent.newest_post_first
    end
  end
end
