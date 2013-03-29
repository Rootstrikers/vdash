require 'spec_helper'

module Feeds
  describe FacebookPostsController do
    describe 'a GET to :index' do
      let(:posts) { [FactoryGirl.create(:posted_facebook_content), FactoryGirl.create(:posted_facebook_content)]}
      let(:action) { -> { get :index, format: :rss } }

      it 'assigns to @posts, with most recently published first' do
        action.call
        assigns(:posts).should == posts.reverse
      end
    end
  end
end
