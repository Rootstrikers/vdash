require 'spec_helper'

describe LikesController do
  let!(:item) { FactoryGirl.create(:link) }
  let!(:user) { FactoryGirl.create(:user) }

  before { sign_in(user) }

  describe 'a POST to :create' do
    let(:action) { ->{ post :create, item_klass: 'Link', item_id: item.id } }

    context 'when the user has clicked on the link' do
      before { user.stub(clicked?: true) }

      context 'when the user has not already liked the item' do
        it 'creates a new Like' do
          expect {
            action.call
          }.to change(Like, :count).by(1)
        end

        it 'associates the Like with the current user' do
          action.call
          Like.last.user.should == user
        end

        it 'associates the Like with the item' do
          action.call
          Like.last.item.should == item
        end

        it 'returns appropriate json' do
          action.call
          response.body.should == '{"id":' + item.id.to_s + ',"itemKlass":"Link","like_count":2,"liked":true,"status":"ok"}'
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

        it 'returns appropriate json' do
          action.call
          response.body.should == '{"id":' + item.id.to_s + ',"itemKlass":"Link","like_count":1,"liked":false,"status":"ok"}'
        end
      end
    end

    context 'when the user has not clicked on the link' do
      it 'does not call toggle_like' do
        user.should_not_receive :toggle_like
        action.call
      end

      it 'renders with status "needs_click"' do
        action.call
          response.body.should == '{"id":' + item.id.to_s + ',"itemKlass":"Link","like_count":1,"liked":false,"status":"needs_click"}'
      end
    end
  end
end
