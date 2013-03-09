require 'spec_helper'

describe Link do
  it { should belong_to :user }
  it { should have_many :likes }
  it { should have_one :twitter_content }
  it { should have_one :facebook_content }

  it { should validate_presence_of :url }
  it { should validate_uniqueness_of :url }
end
