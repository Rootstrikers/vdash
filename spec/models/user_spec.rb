require 'spec_helper'

describe User do
  it { should have_many :links }
  it { should have_many :likes }

  it 'is not an admin by default' do
    User.new.should_not be_admin
  end
end
