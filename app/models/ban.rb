class Ban < ActiveRecord::Base
  belongs_to :user
  belongs_to :created_by, class_name: 'User'
  attr_accessible :user, :reason
end
