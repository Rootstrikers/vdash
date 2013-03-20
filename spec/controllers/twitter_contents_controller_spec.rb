require 'spec_helper'

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

  describe 'a GET to :new' do
    let(:action) { -> { get :new, link_id: link.id } }

    it 'assigns a new TwitterContent to @content' do
      action.call
      assigns(:content).should be_a_new TwitterContent
    end
  end

  describe 'a GET to :edit' do
    let(:action) { -> { get :edit, link_id: link.id, id: twitter_content.id } }

    it 'assigns to @content' do
      action.call
      assigns(:content).should == twitter_content
    end

    it 'raises an exception if user not allowed to edit link' do
      expect {
        get :edit, link_id: link.id, id: FactoryGirl.create(:twitter_content).id
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'a POST to :create' do
    context 'when the twitter content saves' do
      let(:action) { ->{ post :create, link_id: link.id, twitter_content: { body: "Call your senator now!" } } }

      it 'creates a twitter content' do
        expect {
          action.call
        }.to change(TwitterContent, :count).by(1)
      end

      it 'associates the twitter content with the link' do
        action.call
        TwitterContent.last.link.should == link
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(link)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Tweet submission created.'
      end
    end

    context 'when the twitter content is invalid' do
      let(:action) { ->{ post :create, link_id: link.id, twitter_content: { body: nil } } }

      it 'does not create a twitter_content' do
        expect {
          action.call
        }.not_to change(Link, :count)
      end

      it 'renders the new template' do
        action.call
        response.should render_template :new
      end
    end
  end

  describe 'a PUT to :update' do
    context 'when the link saves' do
      let(:action) { ->{ put :update, link_id: link.id, id: twitter_content.id, twitter_content: { body: "New tweet body" } } }

      it 'updates the link' do
        twitter_content.body.should_not == 'New tweet body'
        action.call
        twitter_content.reload.body.should == 'New tweet body'
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(link)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Tweet submission updated.'
      end
    end

    context 'when the link is invalid' do
      let(:action) { ->{ post :update, link_id: link.id, id: twitter_content.id, twitter_content: { body: nil } } }

      it 'does not update the link' do
        original_body = twitter_content.body
        action.call
        twitter_content.reload.body.should == original_body
      end

      it 'renders the edit template' do
        action.call
        response.should render_template :edit
      end
    end
  end

  describe 'a DELETE to :destroy' do
    let(:action) { -> { delete :destroy, link_id: link.id, id: twitter_content.id } }

    it 'destroys the link' do
      action.call
      expect {
        twitter_content.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'redirects to the link' do
      action.call
      response.should redirect_to link_url(link)
    end

    it 'sets the flash' do
      action.call
      flash[:success].should == 'Tweet submission deleted.'
    end
  end
end
