require 'active_support/concern'

module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :item
    has_many :liked_by_users, through: :likes, source: :user, class_name: 'User'
  end
end
