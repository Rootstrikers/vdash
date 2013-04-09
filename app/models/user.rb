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
  has_many :posts
  has_many :contents
  has_many :notices
  has_many :bans

  def self.current
    Thread.current[:current_user]
  end

  def self.existing_user(auth)
    where(auth.slice("provider", "uid")).first
  end

  def self.from_omniauth(auth)
    Rails.logger.debug auth.inspect
  	existing_user(auth) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider     = auth["provider"]
      user.uid          = auth["uid"]
      user.name         = auth["info"]["nickname"] || auth["info"]["name"]
      user.first_name   = auth['info']['first_name']
      user.last_name    = auth['info']['last_name']
      user.full_name    = auth['info']['name']
      user.email        = auth['info']['email']
      user.description  = auth['info']['description']
      user.image        = auth['info']['image']
      user.location     = auth['info']['location']
      user.birthday     = auth['extra']['raw_info']['birthday']
      user.gender       = auth['extra']['raw_info']['gender']
      user.google_url   = auth['extra']['raw_info']['link'] if auth['provider'] == 'google_oauth2'
      user.twitter_url  = auth['info']['urls']['Twitter']   if auth['info']['urls']
      user.facebook_url = auth['info']['urls']['Facebook']  if auth['info']['urls']
      user.website_url  = auth['info']['urls']['Website']   if auth['info']['urls']
    end
  end

  def liked?(item)
    Like.exists?(user_id: self, item_type: item.class.name, item_id: item.id)
  end
end
