module Feeds
  class FacebookPostsController < ApplicationController
    def index
      @posts = Content.posted_to_facebook.newest_post_first
    end
  end
end
