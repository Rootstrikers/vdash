class Link < ActiveRecord::Base
  belongs_to :user
  has_one :facebook_content
  has_one :twitter_content
  has_many :likes, as: :item
  has_many :liked_by_users, through: :likes, source: :user, class_name: 'User'

  validates :url, presence: true, uniqueness: true

  attr_accessible :url, :title, :summary

  def display_name
    title || url
  end

  def error_due_to_duplicate_url?
    errors[:url] == ["has already been taken"]
  end

  def link_with_same_url
    scope = self.class.where(url: url)
    scope = scope.where('id <> ?', id) if id.present?
    scope.first
  end

  def liked_by?(user)
    liked_by_users.exists?(['users.id = ?', user.id])
  end
end
