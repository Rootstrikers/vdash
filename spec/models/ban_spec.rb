require 'spec_helper'

describe Ban do
  it { should belong_to :user }
  it { should belong_to :created_by }
end
