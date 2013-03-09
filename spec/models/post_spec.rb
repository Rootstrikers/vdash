require 'spec_helper'

describe Post do
  it { should belong_to :user }
  it { should belong_to :content }
end
