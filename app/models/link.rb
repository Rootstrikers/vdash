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
  include Likable

  belongs_to :user
  has_many :facebook_contents
  has_many :twitter_contents

  validates :url, presence: true, uniqueness: true

  attr_accessible :url, :title, :summary

  # Well, this should be improved. Sorry.
  def self.unposted
    where(
      "not
      (
        exists (
          select 1 from posts inner join twitter_contents
          on posts.content_id = twitter_contents.id
            and posts.content_type = 'TwitterContent'
          where twitter_contents.link_id = links.id
        )
        and
        exists (
          select 1 from posts inner join facebook_contents
          on posts.content_id = facebook_contents.id
            and posts.content_type = 'FacebookContent'
          where facebook_contents.link_id = links.id
        )
      )"
    )
  end

  def display_name
    title.present? ? title : url
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
