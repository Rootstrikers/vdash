require 'spec_helper'

module Feeds
  describe TweetsController do
    describe 'a GET to :index' do
      let(:tweets) { [FactoryGirl.create(:posted_twitter_content), FactoryGirl.create(:posted_twitter_content)]}
      let(:action) { -> { get :index, format: :rss } }

      it 'assigns to @tweets, with most recently published first' do
        action.call
        assigns(:tweets).should == tweets.reverse
      end
    end
  end
end