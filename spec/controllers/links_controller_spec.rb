require 'spec_helper'

describe LinksController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in(user) }

  let!(:links) {
    [
      FactoryGirl.create(:link, user: user, like_count: 1),
      FactoryGirl.create(:link, user: user, like_count: 5)
    ]
  }
  let(:link) { links.first }

  describe 'a GET to :index' do
    let(:action) { ->{ get :index } }

    it 'assigns to @links, ordered by like count' do
      action.call
      assigns(:links).should == links.reverse
    end

    it 'excludes un-listable links' do
      FactoryGirl.create(:link, user: user, listable: false)
      action.call
      assigns(:links).should == links.reverse
    end

    it 'assigns false to expand_all by default' do
      action.call
      assigns(:expand_all).should be_false
    end

    it 'assigns true to expand_all if params[:write] is "true"' do
      get :index, write: 'true'
      assigns(:expand_all).should be_true
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

    context 'when the link is not modifiable by the current user' do
      before do
        Link.stub(:find).with(link.id.to_s).and_return(link)
        link.stub(:modifiable_by?).with(user).and_return(false)
      end

      it 'redirects to the links_url' do
        action.call
        response.should redirect_to links_url
      end

      it 'sets the flash' do
        action.call
        flash[:error].should == 'This link is not currently modifiable.'
      end
    end
  end

  describe 'a GET to :show' do
    let!(:contents) { [FactoryGirl.create(:content, link: link), FactoryGirl.create(:content, link: link)] }
    let(:action) { ->{ get :show, id: link.id } }

    it 'assigns to @link' do
      action.call
      assigns(:link).should == link
    end

    it 'assigns to @contents' do
      action.call
      assigns(:contents).should == contents
    end
  end

  describe 'a POST to :create' do
    context 'when the link saves' do
      let(:action) { ->{ post :create, link: { url: "http://www.example.com?bananas=true" } } }
      before { request.env["HTTP_REFERER"] = "where_i_came_from" }

      it 'creates a link' do
        expect {
          action.call
        }.to change(Link, :count).by(1)
      end

      it 'redirects back' do
        action.call
        response.should redirect_to 'where_i_came_from'
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Link created.'
      end
    end

    context 'when a link with the same url already exists' do
      let!(:old_link) { FactoryGirl.create(:link, url: "http://www.example.com?bananas=true" )}
      let(:action) { ->{ post :create, link: { url: "http://www.example.com?bananas=true" } } }

      it 'redirects to links#index' do
        action.call
        response.should redirect_to links_url
      end

      it 'sets the flash' do
        action.call
        flash[:alert].should == 'Link has already been submitted!'
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

      context 'when the link is not modifiable by the current user' do
        before do
          Link.stub(:find).with(link.id.to_s).and_return(link)
          link.stub(:modifiable_by?).with(user).and_return(false)
        end

        it 'redirects to the links_url' do
          action.call
          response.should redirect_to links_url
        end

        it 'sets the flash' do
          action.call
          flash[:error].should == 'This link is not currently modifiable.'
        end
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

  describe 'a DELETE to :destroy' do
    let(:action) { -> { delete :destroy, id: link.id } }

    it 'marks the link as deleted' do
      Timecop.freeze(Time.now) do
        action.call
        Link.unscoped.find(link.id).deleted_at.should == Time.now
      end
    end

    it 'redirects to the links list' do
      action.call
      response.should redirect_to links_url
    end

    it 'sets the flash' do
      action.call
      flash[:success].should == 'Link deleted.'
    end

    context 'when the link is not modifiable by the current user' do
      before do
        Link.stub(:find).with(link.id.to_s).and_return(link)
        link.stub(:modifiable_by?).with(user).and_return(false)
      end

      it 'redirects to the links_url' do
        action.call
        response.should redirect_to links_url
      end

      it 'sets the flash' do
        action.call
        flash[:error].should == 'This link is not currently modifiable.'
      end
    end
  end
end
