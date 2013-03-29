shared_examples "it requires an admin" do
  context 'when a non-admin is logged in' do
    before { controller.stub(current_user: stub(admin?: false)) }

    it 'redirects to /signin' do
      get :index
      response.should redirect_to '/signin'
    end

    it 'sets the flash' do
      get :index
      flash[:alert].should == 'You must be an admin to access this area.'
    end
  end
end