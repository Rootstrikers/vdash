require 'active_support/concern'

module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :item, dependent: :destroy
    has_many :liked_by_users, through: :likes, source: :user, class_name: 'User'
    after_touch :set_like_count
    after_create :add_like
  end

  module ClassMethods
    def ordered
      order("#{table_name}.like_count desc, #{table_name}.created_at desc")
    end
  end

  private
  def set_like_count
    update_attribute(:like_count, likes.count)
  end

  def add_like
    likes << Like.create(user: user) unless like_count.try(:>, 0)
  end
end
