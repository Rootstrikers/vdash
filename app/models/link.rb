class Link < ActiveRecord::Base
  belongs_to :user
  has_one :facebook_content
  has_one :twitter_content
  has_many :likes, as: :item

  validates :url, presence: true, uniqueness: true

  attr_accessible :url

  def error_due_to_duplicate_url?
    errors[:url] == ["has already been taken"]
  end

  def link_with_same_url
    scope = self.class.where(url: url)
    scope = scope.where('id <> ?', id) if id.present?
    scope.first
  end
end
