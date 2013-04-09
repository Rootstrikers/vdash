require 'spec_helper'

describe RemoteLinksController do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    RemoteLink.any_instance.stub(:complain_if_bad_url)
  end

  describe 'a GET to :show' do
    it 'renders the remote link as json' do
      get :show, url: "#{Rails.root}/spec/fixtures/remote_link.html"
      response.body.should == '{"title":"This is my title","first_paragraph":"This is my paragraph."}'
    end
  end
end
