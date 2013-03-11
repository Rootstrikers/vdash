# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  content_id   :integer
#  content_type :string(255)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Post do
  it { should belong_to :user }
  it { should belong_to :content }
end
