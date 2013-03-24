require 'spec_helper'

module Admin
  describe NoticesController do
    it_behaves_like "it requires a user"

    let(:user) { FactoryGirl.create(:admin) }
    before { sign_in(user) }

    let!(:notices) {
      [
        FactoryGirl.create(:notice, user: user),
        FactoryGirl.create(:notice, user: user)
      ]
    }
    let(:notice) { notices.first }

    describe 'a GET to :index' do
      let(:action) { ->{ get :index } }

      it 'assigns to @notices, newest first' do
        action.call
        assigns(:notices).should == notices.reverse
      end
    end

    describe 'a GET to :new' do
      let(:action) { -> { get :new } }

      it 'assigns a new Notice to @notice' do
        action.call
        assigns(:notice).should be_a_new Notice
      end
    end

    describe 'a GET to :edit' do
      let(:action) { -> { get :edit, id: notice.id } }

      it 'assigns to @notice' do
        action.call
        assigns(:notice).should == notice
      end
    end

    describe 'a POST to :create' do
      context 'when the notice saves' do
        let(:action) { ->{ post :create, notice: { body: "Stuff and things" } } }

        it 'creates a notice' do
          expect {
            action.call
          }.to change(Notice, :count).by(1)
        end

        it 'redirects to the list of notices' do
          action.call
          response.should redirect_to admin_notices_url
        end

        it 'sets the flash' do
          action.call
          flash[:success].should == 'Notice created.'
        end
      end

      context 'when the notice is invalid' do
        let(:action) { ->{ post :create, notice: { body: nil } } }

        it 'does not create a notice' do
          expect {
            action.call
          }.not_to change(Notice, :count)
        end

        it 'renders the new template' do
          action.call
          response.should render_template :new
        end
      end
    end

    describe 'a PUT to :update' do
      context 'when the notice saves' do
        let(:action) { ->{ put :update, id: notice.id, notice: { body: "New body" } } }

        it 'updates the notice' do
          notice.body.should_not == "New body"
          action.call
          notice.reload.body.should == "New body"
        end

        it 'redirects to the list of notices' do
          action.call
          response.should redirect_to admin_notices_url
        end

        it 'sets the flash' do
          action.call
          flash[:success].should == 'Notice updated.'
        end
      end

      context 'when the notice is invalid' do
        let(:action) { ->{ post :update, id: notice.id, notice: { body: nil } } }

        it 'does not update the notice' do
          original_body = notice.body
          action.call
          notice.reload.body.should == original_body
        end

        it 'renders the edit template' do
          action.call
          response.should render_template :edit
        end
      end
    end

    describe 'a DELETE to :destroy' do
      let(:action) { -> { delete :destroy, id: notice.id } }

      it 'destroys the notice' do
        action.call
        expect {
          notice.reload
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'redirects to the notices list' do
        action.call
        response.should redirect_to admin_notices_url
      end

      it 'sets the flash' do
        action.call
        flash[:success].should == 'Notice deleted.'
      end
    end
  end
end
