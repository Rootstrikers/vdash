module Feeds
  class TweetsController < ApplicationController
    def index
      @tweets = TwitterContent.newest_post_first
    end
  end
end
