require 'spec_helper'

module Admin
  describe BansController do
    it_behaves_like "it requires an admin"

    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in(admin) }

    describe 'a GET to :index' do
      let!(:bans) { [FactoryGirl.create(:ban), FactoryGirl.create(:ban)] }
      let(:action) { ->{ get :index } }

      it 'assigns to @bans' do
        action.call
        assigns(:bans).should =~ bans
      end
    end
  end
end
