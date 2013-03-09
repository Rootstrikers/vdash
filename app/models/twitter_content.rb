class TwitterContent < ActiveRecord::Base
  include ContentBase

  validates :body, length: { maximum: 140 }
end
