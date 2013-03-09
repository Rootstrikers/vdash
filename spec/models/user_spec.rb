require 'spec_helper'

describe User do
  it { should have_many :links }
  it { should have_many :likes }
end
