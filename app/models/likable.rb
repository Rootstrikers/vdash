require 'active_support/concern'

module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :item
    has_many :liked_by_users, through: :likes, source: :user, class_name: 'User'
    after_touch :set_like_count
  end

  module ClassMethods
    def ordered
      order('like_count desc')
    end
  end

  private
  def set_like_count
    update_attribute(:like_count, likes.count)
  end
end
