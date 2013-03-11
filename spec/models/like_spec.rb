# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  item_type  :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Like do
  it { should belong_to :user }
  it { should belong_to :item }
end
