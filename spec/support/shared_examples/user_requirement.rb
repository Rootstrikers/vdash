shared_examples "it requires a user" do
  context 'when no user is logged in' do
    before { controller.stub(current_user: nil) }

    it 'redirects to the root_url' do
      get :index
      response.should redirect_to root_url
    end
  end
end