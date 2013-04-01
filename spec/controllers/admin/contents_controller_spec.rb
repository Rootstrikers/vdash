require 'spec_helper'

module Admin
  describe ContentsController do
    let(:user) { FactoryGirl.create(:admin) }
    before { sign_in(user) }

    let!(:link) { FactoryGirl.create(:link) }
    let!(:contents) {
      [
        FactoryGirl.create(:content, link: link, user: user, like_count: 1),
        FactoryGirl.create(:content, link: link, user: user, like_count: 5)
      ]
    }
    let(:content) { contents.first }

    describe 'a GET to :index, ordered by like_count' do
      let(:action) { -> { get :index } }

      it 'assigns to @contents, ordered' do
        action.call
        assigns(:contents).should == contents.reverse
      end
    end
  end
end
