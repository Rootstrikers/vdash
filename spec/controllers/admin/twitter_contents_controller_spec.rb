require 'spec_helper'

module Admin
  describe TwitterContentsController do
    let(:user) { FactoryGirl.create(:admin) }
    before { sign_in(user) }

    let!(:link) { FactoryGirl.create(:link) }
    let!(:twitter_contents) {
      [
        FactoryGirl.create(:twitter_content, link: link, user: user, like_count: 1),
        FactoryGirl.create(:twitter_content, link: link, user: user, like_count: 5)
      ]
    }
    let(:twitter_content) { twitter_contents.first }

    describe 'a GET to :index' do
      let(:action) { -> { get :index } }

      it 'assigns to @contents, ordered by link_count' do
        action.call
        assigns(:contents).should == twitter_contents.reverse
      end
    end
  end
end
