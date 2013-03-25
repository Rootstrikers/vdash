require 'spec_helper'

module Admin
  describe FacebookContentsController do
    let(:user) { FactoryGirl.create(:admin) }
    before { sign_in(user) }

    let!(:link) { FactoryGirl.create(:link) }
    let!(:facebook_contents) {
      [
        FactoryGirl.create(:facebook_content, link: link, user: user, like_count: 1),
        FactoryGirl.create(:facebook_content, link: link, user: user, like_count: 5)
      ]
    }
    let(:facebook_content) { facebook_contents.first }

    describe 'a GET to :index, ordered by like_count' do
      let(:action) { -> { get :index } }

      it 'assigns to @contents, ordered' do
        action.call
        assigns(:contents).should == facebook_contents.reverse
      end
    end
  end
end
