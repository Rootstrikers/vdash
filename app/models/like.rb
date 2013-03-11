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

class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, polymorphic: true
  attr_accessible :item
end
