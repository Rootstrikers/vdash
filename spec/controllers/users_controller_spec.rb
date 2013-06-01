require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in(user) }

  describe 'a GET to :show' do
    before { User.stub(:find).with(user.id.to_s).and_return(user) }
    let(:action) { ->{ get :show, id: user.id } }

    it 'assigns to @user' do
      action.call
      assigns(:user).should == user
    end

    it 'assigns to @links' do
      links = double
      user.stub(:links).and_return(links)
      action.call
      assigns(:links).should == links
    end

    it 'assigns to @contents' do
      contents = double
      user.stub(:contents).and_return(contents)
      action.call
      assigns(:contents).should == contents
    end
  end

  describe 'a GET to :edit' do
    context 'when editing yourself' do
      let(:action) { ->{ get :edit, id: user.id} }

      it 'assigns to @user' do
        action.call
        assigns(:user).should == user
      end
    end

    context 'when attempting to edit someone else' do
      let(:action) { ->{ get :edit, id: FactoryGirl.create(:user).id } }

      it 'redirects to the root url' do
        action.call
        response.should redirect_to root_url
      end

      it 'sets the flash' do
        action.call
        flash[:error].should == 'You can only edit yourself, buddy.'
      end
    end
  end

  describe 'a PUT to :update' do
    let(:action) { ->{ put :update, id: user.id, user: {} } }

    context 'when the user updates' do
      before { User.any_instance.stub(update_attributes: true) }

      it 'redirects to the user show page' do
        action.call
        response.should redirect_to user_url(user)
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == "Profile successfully updated."
      end
    end

    context 'when the user does not update' do
      before { User.any_instance.stub(update_attributes: false) }

      it 'renders the edit template' do
        action.call
        response.should render_template :edit
      end
    end
  end
end
