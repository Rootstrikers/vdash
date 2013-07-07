require 'spec_helper'

describe SessionsController, 'OmniAuth' do
  describe 'a POST to :create' do
    let(:user) { FactoryGirl.create(:user, name: 'George') }
    let(:auth) { double }
    let(:action) { ->{ post :create, provider: 'facebook' } }

    before do
      controller.stub(env: { "omniauth.auth" => auth })
      User.stub(from_omniauth: user)
    end

    it 'gets user from omniauth auth' do
      User.should_receive(:from_omniauth).with(auth).and_return(user)
      action.call
    end

    it 'sets the user id in the session' do
      action.call
      session[:user_id].should == user.id
    end

    context 'when after_signin_url is present in the session' do
      before { session[:after_signin_url] = 'http://www.example.com' }

      it 'redirects to it' do
        action.call
        response.should redirect_to 'http://www.example.com'
      end
    end

    context 'when after_signin_url is not present in the session' do
      it 'redirects to the root_url' do
        action.call
        response.should redirect_to root_url
      end
    end

    it 'sets the flash' do
      action.call
      flash[:notice].should == "Hey there, <a href=\"/users/#{user.id}\">George</a>! Let's get to work."
    end
  end
end
