require 'spec_helper'

describe ContentsController do
  let(:user) { FactoryGirl.create(:user) }
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

  describe 'a GET to :new' do
    let(:action) { -> { get :new, link_id: link.id } }

    it 'assigns a new Content to @content' do
      action.call
      assigns(:content).should be_a_new Content
    end
  end

  describe 'a GET to :edit' do
    let(:action) { -> { get :edit, link_id: link.id, id: content.id } }

    it 'assigns to @content' do
      action.call
      assigns(:content).should == content
    end

    it 'raises an exception if user not allowed to edit link' do
      expect {
        get :edit, link_id: link.id, id: FactoryGirl.create(:content).id
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'a POST to :create' do
    context 'when the facebook content saves' do
      let(:action) { ->{ post :create, link_id: link.id, content: { body: "Call your senator now!" } } }

      it 'creates a facebook content' do
        expect {
          action.call
        }.to change(Content, :count).by(1)
      end

      it 'associates the facebook content with the link' do
        action.call
        Content.last.link.should == link
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(link)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Post submission created.'
      end
    end

    context 'when the facebook content is invalid' do
      let(:action) { ->{ post :create, link_id: link.id, content: { body: nil } } }

      it 'does not create a content' do
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
      let(:action) { ->{ put :update, link_id: link.id, id: content.id, content: { body: "New content post body" } } }

      it 'updates the link' do
        content.body.should_not == 'New content post body'
        action.call
        content.reload.body.should == 'New content post body'
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(link)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Post submission updated.'
      end
    end

    context 'when the link is invalid' do
      let(:action) { ->{ post :update, link_id: link.id, id: content.id, content: { body: nil } } }

      it 'does not update the link' do
        original_body = content.body
        action.call
        content.reload.body.should == original_body
      end

      it 'renders the edit template' do
        action.call
        response.should render_template :edit
      end
    end
  end

  describe 'a DELETE to :destroy' do
    let(:action) { -> { delete :destroy, link_id: link.id, id: content.id } }

    it 'sets deleted_at on the content' do
      Timecop.freeze(Time.now) do
        action.call
        content.reload.deleted_at.should == Time.now
      end
    end

    it 'redirects to the link' do
      action.call
      response.should redirect_to link_url(link)
    end

    it 'sets the flash' do
      action.call
      flash[:success].should == 'Post submission deleted.'
    end
  end
end
