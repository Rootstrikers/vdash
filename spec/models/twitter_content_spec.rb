require 'spec_helper'

describe TwitterContent do
  it_behaves_like 'content'

  it { should ensure_length_of(:body).is_at_most(140) }
end
