# For sharing functionality between FacebookContent and TwitterContent
require 'active_support/concern'

module ContentBase
  extend ActiveSupport::Concern

  included do
    belongs_to :link
    belongs_to :user

    has_many :posts, as: :content

    validates :body, presence: true

    attr_accessible :body, :link_id
  end

  module ClassMethods
    def unposted
      where("not exists (select 1 from posts where content_id = #{table_name}.id and content_type = ?)", name.to_s)
    end
  end

  def post!
    User.current.posts << Post.create(content: self)
  end
end
