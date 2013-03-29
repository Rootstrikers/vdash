shared_examples "it requires a user" do
  context 'when no user is logged in' do
    before { controller.stub(current_user: nil) }

    it 'redirects to /signin' do
      get :index
      response.should redirect_to '/signin'
    end

    it 'sets the flash' do
      get :index
      flash[:alert].should == 'You must sign in to access this area.'
    end
  end
end