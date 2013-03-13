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

    context 'when the user has not already liked the item' do
      it 'creates a new Like' do
        expect {
          action.call
        }.to change(Link, :count).by(1)
      end

      it 'associates the Like with the current user' do
        action.call
        Like.last.user.should == user
      end

      it 'associates the Like with the item' do
        action.call
        Like.last.item.should == item
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

    context 'when the user has already liked the item' do
      let!(:like) { FactoryGirl.create(:like, user: user, item: item) }

      it 'deletes the Like' do
        action.call
        expect {
          like.reload
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'redirects to refering url' do
        action.call
        response.should redirect_to 'where_i_came_from'
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Unliked.'
      end
    end
  end
end
