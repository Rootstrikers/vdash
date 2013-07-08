require 'spec_helper'

describe SessionsController, 'OmniAuth' do
  describe 'a POST to :create' do
    let(:user) { FactoryGirl.create(:user, name: 'George') }
    let(:auth) { { 'provider' => 'facebook', 'uid' => '12345', 'info' => { 'name' => 'George' } } }
    let(:action) { ->{ post :create, provider: 'facebook' } }

    before do
      controller.stub(env: { "omniauth.auth" => auth })
    end

    context 'when there is no current user' do
      before do
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

    context 'when user is already logged in' do
      before { controller.stub(current_user: user) }

      context 'when linked account already exists for that provider' do
        before { user.linked_accounts.create(provider: 'facebook') }
        it 'does not create a new User' do
          expect {
            action.call
          }.not_to change(User, :count)
        end

        it 'does not create a new LinkedAccount' do
          expect {
            action.call
          }.not_to change(LinkedAccount, :count)
        end

        it 'redirects to root url' do
          action.call
          response.should redirect_to root_url
        end

        it 'sets the flash' do
          action.call
          flash[:notice].should == 'You are already signed in with that account!'
        end
      end

      context 'when linked account does not already exist' do
        it 'does not create a new User' do
          expect {
            action.call
          }.not_to change(User, :count)
        end

        it 'creates a new LinkedAccount' do
          expect {
            action.call
          }.to change(LinkedAccount, :count).by(1)
        end

        it 'associates the linked account with the user' do
          action.call
          LinkedAccount.last.user.should == user
        end

        it 'redirects to linked accounts index' do
          action.call
          response.should redirect_to linked_accounts_url
        end

        it 'sets the flash' do
          action.call
          flash[:notice].should == 'You have linked a new social media account!'
        end
      end
    end
  end
end
