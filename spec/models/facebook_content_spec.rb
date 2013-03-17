# == Schema Information
#
# Table name: facebook_contents
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe FacebookContent do
  it_behaves_like 'content'
  it_behaves_like 'it is likable'
end
