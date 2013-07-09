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

      context 'when dealing with facebook' do
        let(:action) { ->{ post :create, type: 'facebook', content_id: content.id } }

        it 'redirects to facebook' do
          action.call
          pp response.headers
          response.headers['Location'].should =~ %r(\Ahttps://www.facebook.com/dialog/feed\?app_id=129144613947348&description=MyText&from=380776225267938&link=http%3A%2F%2Fwww.example.com%3Fnumber%3D\d&name=&redirect_uri=http%3A%2F%2Ftest.host%2Fadmin%2Fposts%2Fcallback%3Fservice%3Dfacebook)
        end
      end
    end

    describe 'a GET to :callback' do
      let(:content) { FactoryGirl.create(:content) }
      let(:action) { ->{ get :callback, content_id: content.id, service: 'facebook' }}

      it 'calls post on the content' do
        Content.stub(:find).with(content.id.to_s).and_return(content)
        content.should_receive :post!
        action.call
      end

      it 'redirects to the posts index' do
        action.call
        response.should redirect_to contents_url
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Posted!'
      end

    end
  end
end
