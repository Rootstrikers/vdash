module Feeds
  class TweetsController < ApplicationController
    def index
      @tweets = Content.posted_to_twitter.newest_post_first
    end
  end
end
