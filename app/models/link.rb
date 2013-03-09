class Link < ActiveRecord::Base
  belongs_to :user
  has_one :facebook_content
  has_one :twitter_content
  has_many :likes, as: :item

  validates :url, presence: true, uniqueness: true

  attr_accessible :url
end
