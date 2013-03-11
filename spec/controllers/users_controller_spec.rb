require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in(user) }

  describe 'a GET to :show' do
    let(:action) { ->{ get :show, id: user.id } }

    it 'assigns to @user' do
      action.call
      assigns(:user).should == user
    end
  end
end
