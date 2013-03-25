# == Schema Information
#
# Table name: twitter_contents
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe TwitterContent do
  it_behaves_like 'content'
  it_behaves_like 'it is likable'
  it_behaves_like 'it is deletable'

  it { should ensure_length_of(:body).is_at_most(140) }
end
