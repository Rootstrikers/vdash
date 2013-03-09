# For sharing functionality between FacebookContent and TwitterContent
require 'active_support/concern'

module ContentBase
  extend ActiveSupport::Concern

  included do
    belongs_to :link
    belongs_to :user

    has_many :posts, as: :content

    attr_accessible :body
  end
end
