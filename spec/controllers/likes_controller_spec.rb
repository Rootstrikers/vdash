require 'spec_helper'

describe LikesController do
  let(:item) { FactoryGirl.create(:link) }
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe 'a POST to :create' do
    let(:action) { ->{ post :create, item_klass: 'Link', item_id: item.id } }

    it 'creates a new Like' do
      expect {
        action.call
      }.to change(Link, :count).by(1)
    end

    it 'redirects to refering url' do
      action.call
      response.should redirect_to 'where_i_came_from'
    end

    it 'sets the flash' do
      action.call
      flash[:success].should == 'Liked!'
    end
  end
end
