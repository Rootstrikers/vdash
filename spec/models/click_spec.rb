require 'spec_helper'

describe Click do
  it { should belong_to :user }
  it { should belong_to :item }
end
