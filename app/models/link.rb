# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string(255)
#  summary    :text
#

class Link < ActiveRecord::Base
  belongs_to :user
  has_many :facebook_contents
  has_many :twitter_contents
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
