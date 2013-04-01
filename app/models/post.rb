# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  content_id   :integer
#  content_type :string(255)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Record when a moderator has posted a piece of content
class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :content
  attr_accessible :content

  def self.newest_first
    order('posts.created_at desc')
  end

  def self.facebook
    where(type: 'Posts::Facebook')
  end

  def self.twitter
    where(type: 'Posts::Twitter')
  end
end
