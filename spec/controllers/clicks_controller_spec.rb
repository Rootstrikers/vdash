require 'spec_helper'

describe ClicksController do
  let(:item) { FactoryGirl.create(:link) }
  let(:user) { FactoryGirl.create(:user) }

  before { sign_in(user) }

  describe 'a POST to :create' do
    let(:action) { ->{ post :create, item_klass: 'Link', item_id: item.id } }

    context 'when the user has not already liked the item' do
      it 'creates a new Click' do
        expect {
          action.call
        }.to change(Click, :count).by(1)
      end

      it 'associates the Click with the current user' do
        action.call
        Click.last.user.should == user
      end

      it 'associates the Click with the item' do
        action.call
        Click.last.item.should == item
      end

      it 'returns empty json' do
        action.call
        response.body.should == '{}'
      end
    end

    context 'when the user has already liked the item' do
      let!(:click) { FactoryGirl.create(:click, user: user, item: item) }

      it 'does not create a click' do
        expect {
          action.call
        }.not_to change(Click, :count)
      end

      it 'returns empty json' do
        action.call
        response.body.should == '{}'
      end
    end
  end
end
