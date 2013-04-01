require 'spec_helper'

module Admin
  describe PostsController do
    before { sign_in(FactoryGirl.create(:admin)) }

    describe 'a GET to :index' do
      let(:posts) { [FactoryGirl.create(:post), FactoryGirl.create(:post)] }
      let(:action) { ->{ get :index } }

      it 'assigns to @posts, newest first' do
        action.call
        assigns(:posts).should == posts.reverse
      end
    end

    describe 'a POST to :create' do
      let(:content) { FactoryGirl.create(:content) }
      let(:action) { ->{ post :create, content_type: 'twitter', content_id: content.id }}

      it 'calls post on the content' do
        Content.stub(:find).with(content.id.to_s).and_return(content)
        content.should_receive :post!
        action.call
      end

      it 'redirects to the posts index' do
        action.call
        response.should redirect_to admin_contents_url
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Posted!'
      end

    end
  end
end
