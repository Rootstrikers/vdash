require 'spec_helper'

module Admin
  module Users
    describe BansController do
      let(:current_user) { FactoryGirl.create(:admin) }
      before { sign_in(current_user) }

      let(:user) { FactoryGirl.create(:user) }
      let!(:bans) { [FactoryGirl.create(:ban, user: user), FactoryGirl.create(:ban, user: user)] }
      let(:ban)  { bans.first }

      describe 'a GET to :index' do
        let(:action) { ->{ get :index, user_id: user.id } }

        it 'assigns all bans associated with a user to @bans' do
          action.call
          assigns(:bans).should == bans
        end
      end

      describe 'a GET to :new' do
        let(:action) { ->{ get :new, user_id: user.id } }

        it 'assigns a new Ban to @ban' do
          action.call
          assigns(:ban).should be_a_new Ban
        end
      end

      describe 'a POST to :create' do
        let(:action) { ->{ post :create, user_id: user.id, ban: { reason: 'Being bad.' } } }

        it 'creates a Ban' do
          expect {
            action.call
          }.to change(Ban, :count).by(1)
        end

        it 'sets the reason' do
          action.call
          Ban.last.reason.should == 'Being bad.'
        end

        it 'associates the Ban with the current user' do
          action.call
          Ban.last.created_by.should == current_user
        end

        it 'associates the Ban with the banned user' do
          action.call
          Ban.last.user.should == user
        end

        it 'redirects to the user' do
          action.call
          response.should redirect_to user_url(user)
        end

        it 'sets the flash' do
          action.call
          flash[:success].should == 'User has been banned.'
        end
      end

      describe 'a DELETE to :destroy' do
        let!(:ban) { FactoryGirl.create(:ban, user: user) }
        let(:action) { ->{ delete :destroy, user_id: user.id, id: ban.id } }

        it 'sets the lifted at timestamp' do
          ban.lifted_at.should == nil
          Timecop.freeze(Time.now) do
            action.call
            ban.reload.lifted_at.should == Time.now
          end
        end

        it 'redirects to the user' do
          action.call
          response.should redirect_to user_url(user)
        end

        it 'sets the flash' do
          action.call
          flash[:success].should == 'User has been un-banned.'
        end
      end
    end
  end
end
