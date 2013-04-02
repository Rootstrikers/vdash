class Ban < ActiveRecord::Base
  belongs_to :user
  belongs_to :created_by, class_name: 'User'
  attr_accessible :user, :reason

  delegate :name, to: :created_by, prefix: true

  def self.unlifted
    where(lifted_at: nil)
  end

  def lifted?
    lifted_at.present?
  end
end
