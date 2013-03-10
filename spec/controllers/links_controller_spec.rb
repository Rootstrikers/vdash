require 'spec_helper'

describe LinksController do
  it_behaves_like "it requires a user"

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in(user) }

  let!(:links) {
    [
      FactoryGirl.create(:link, user: user),
      FactoryGirl.create(:link, user: user)
    ]
  }
  let(:link) { links.first }

  describe 'a GET to :index' do
    let(:action) { ->{ get :index } }

    it 'assigns to @links' do
      action.call
      assigns(:links).should == links
    end
  end

  describe 'a GET to :new' do
    let(:action) { -> { get :new } }

    it 'assigns a new Link to @link' do
      action.call
      assigns(:link).should be_a_new Link
    end
  end

  describe 'a GET to :edit' do
    let(:action) { -> { get :edit, id: link.id } }

    it 'assigns to @link' do
      action.call
      assigns(:link).should == link
    end

    it 'raises an exception if user not allowed to edit link' do
      expect {
        get :edit, id: FactoryGirl.create(:link).id
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'a GET to :show' do
    let(:action) { ->{ get :show, id: link.id } }

    it 'assigns to @link' do
      action.call
      assigns(:link).should == link
    end
  end

  describe 'a POST to :create' do
    context 'when the link saves' do
      let(:action) { ->{ post :create, link: { url: "http://www.example.com?bananas=true" } } }

      it 'creates a link' do
        expect {
          action.call
        }.to change(Link, :count).by(1)
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(Link.last)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Link created.'
      end
    end

    context 'when the link is invalid' do
      let(:action) { ->{ post :create, link: { url: nil } } }

      it 'does not create a link' do
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
      let(:action) { ->{ put :update, id: link.id, link: { url: "http://www.example.com?bananas=true" } } }

      it 'updates the link' do
        link.url.should_not == 'http://www.example.com?bananas=true'
        action.call
        link.reload.url.should == 'http://www.example.com?bananas=true'
      end

      it 'redirects to the link' do
        action.call
        response.should redirect_to link_url(link)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Link updated.'
      end
    end

    context 'when the link is invalid' do
      let(:action) { ->{ post :update, id: link.id, link: { url: nil } } }

      it 'does not update the link' do
        original_url = link.url
        action.call
        link.reload.url.should == original_url
      end

      it 'renders the edit template' do
        action.call
        response.should render_template :edit
      end
    end
  end
end
