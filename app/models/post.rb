class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :content, polymorphic: true
  attr_accessible :content
end
