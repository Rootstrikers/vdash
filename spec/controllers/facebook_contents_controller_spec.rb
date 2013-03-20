require 'spec_helper'

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

  describe 'a GET to :index' do
    let(:action) { -> { get :index } }

    it 'assigns to @contents, ordered' do
      action.call
      assigns(:contents).should == facebook_contents.reverse
    end
  end

  describe 'a GET to :new' do
    let(:action) { -> { get :new, link_id: link.id } }

    it 'assigns a new FacebookContent to @content' do
      action.call
      assigns(:content).should be_a_new FacebookContent
    end
  end

  describe 'a GET to :edit' do
    let(:action) { -> { get :edit, link_id: link.id, id: facebook_content.id } }

    it 'assigns to @content' do
      action.call
      assigns(:content).should == facebook_content
    end

    it 'raises an exception if user not allowed to edit link' do
      expect {
        get :edit, link_id: link.id, id: FactoryGirl.create(:facebook_content).id
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'a POST to :create' do
    context 'when the facebook content saves' do
      let(:action) { ->{ post :create, link_id: link.id, facebook_content: { body: "Call your senator now!" } } }

      it 'creates a facebook content' do
        expect {
          action.call
        }.to change(FacebookContent, :count).by(1)
      end

      it 'associates the facebook content with the link' do
        action.call
        FacebookContent.last.link.should == link
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(link)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Facebook post submission created.'
      end
    end

    context 'when the facebook content is invalid' do
      let(:action) { ->{ post :create, link_id: link.id, facebook_content: { body: nil } } }

      it 'does not create a facebook_content' do
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
      let(:action) { ->{ put :update, link_id: link.id, id: facebook_content.id, facebook_content: { body: "New Facebook post body" } } }

      it 'updates the link' do
        facebook_content.body.should_not == 'New Facebook post body'
        action.call
        facebook_content.reload.body.should == 'New Facebook post body'
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(link)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Facebook post submission updated.'
      end
    end

    context 'when the link is invalid' do
      let(:action) { ->{ post :update, link_id: link.id, id: facebook_content.id, facebook_content: { body: nil } } }

      it 'does not update the link' do
        original_body = facebook_content.body
        action.call
        facebook_content.reload.body.should == original_body
      end

      it 'renders the edit template' do
        action.call
        response.should render_template :edit
      end
    end
  end

  describe 'a DELETE to :destroy' do
    let(:action) { -> { delete :destroy, link_id: link.id, id: facebook_content.id } }

    it 'destroys the link' do
      action.call
      expect {
        facebook_content.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'redirects to the link' do
      action.call
      response.should redirect_to link_url(link)
    end

    it 'sets the flash' do
      action.call
      flash[:success].should == 'Facebook post submission deleted.'
    end
  end
end
