require 'spec_helper'

describe RemoteLinksController do
  let(:fixture_path) { "#{Rails.root}/spec/fixtures/remote_link.html" }
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    RemoteLink.any_instance.stub(:complain_if_bad_url)
  end

  describe 'a GET to :show' do
    it 'renders the remote link as json' do
      RemoteLink::ResolvedUrl.stub_chain(:new, :to_s).and_return("#{Rails.root}/spec/fixtures/remote_link.html")
      get :show, url: fixture_path
      response.body.should == '{"title":"This is my title","first_paragraph":"This is my paragraph."}'
    end
  end
end
