class Notice < ActiveRecord::Base
  belongs_to :user
  validates :body, presence: true
  attr_accessible :active, :body

  after_save :ensure_only_one_active

  def self.active
    where(:active => true).first
  end

  private
  def ensure_only_one_active
    self.class.update_all({ active: false }, ['id <> ?', id]) if active?
  end
end
