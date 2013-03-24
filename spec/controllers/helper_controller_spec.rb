require 'spec_helper'

describe HelpController do
  describe 'a GET to :index' do
    let(:action) { ->{ get :index } }

    it 'renders' do
      action.call
      response.should render_template :index
    end
  end
end
