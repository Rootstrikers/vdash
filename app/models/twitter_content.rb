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

class TwitterContent < ActiveRecord::Base
  include ContentBase
  include Likable

  validates :body, length: { maximum: 140 }
end
