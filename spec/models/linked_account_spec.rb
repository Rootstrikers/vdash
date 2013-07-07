require 'spec_helper'

describe LinkedAccount do
  it { should belong_to :user }
end
