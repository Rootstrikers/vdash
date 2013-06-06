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
  has_many :clicks
  has_many :posts
  has_many :contents
  has_many :notices
  has_many :bans

  validates :google_url,   format: { with: /google\./ },   allow_blank: true
  validates :facebook_url, format: { with: /facebook\./ }, allow_blank: true
  validates :twitter_url,  format: { with: /twitter\./ },  allow_blank: true
  validates :email,        format: { with: /.+@.+/ },      allow_blank: true

  attr_accessible :name, :google_url, :facebook_url, :twitter_url, :website_url, :email,
    :public_contact_information

  def self.current
    Thread.current[:current_user]
  end

  def self.existing_user(auth)
    where(auth.slice("provider", "uid")).first
  end

  def self.from_omniauth(auth)
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

  def self.twitter
    where(name: 'Twitter', provider: 'system').first
  end

  def liked?(item)
    likes.exists?(item_id: item.id, item_type: item.class.name)
  end

  def clicked?(item)
    item = item.link if !item.is_a?(Link) and item.respond_to?(:link)
    clicks.exists?(item_id: item.id, item_type: item.class.name)
  end

  def able_to_like?(item)
    clicked?(item) or item.user == self or (item.respond_to?(:link) and item.link.user == self)
  end

  def toggle_like(item)
    liked?(item) ? unlike(item) : like(item)
  end

  def banned?
    bans.unlifted.exists?
  end

  def ban
    bans.unlifted.newest_first.first
  end

  def possible_contact_methods
    [
      {
        label: 'E-mail',
        value: email
      },
      {
        label: 'Google+',
        value: google_url
      },
      {
        label: 'Facebook',
        value: facebook_url
      },
      {
        label: 'Twitter',
        value: twitter_url
      },
      {
        label: 'Personal Website',
        value: website_url
      }
    ]
  end

  def contact_methods
    possible_contact_methods.reject { |contact_method| contact_method[:value].blank? }
  end

  private
  def unlike(item)
    likes.where(item_type: item.class.name, item_id: item.id).first.destroy
  end

  def like(item)
    likes << Like.new(item: item)
  end
end
