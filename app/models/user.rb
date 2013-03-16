# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean
#  uid        :string(255)
#  name       :string(255)
#  provider   :string(255)
#

class User < ActiveRecord::Base
  has_many :links
  has_many :likes
  has_many :facebook_contents
  has_many :twitter_contents

  def self.from_omniauth(auth)
  	where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
  	create! do |user|
  		user.provider = auth["provider"]
  		user.uid = auth["uid"]
  		user.name = auth["info"]["nickname"]
  	end
  end

  def liked?(item)
    Like.exists?(user_id: self, item_type: item.class.name, item_id: item.id)
  end
end
