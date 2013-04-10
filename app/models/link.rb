# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string(255)
#  summary    :text
#

class Link < ActiveRecord::Base
  include Likable
  include Deletable

  belongs_to :user
  has_many :contents

  validates :url, uniqueness: true
  validate :url_present

  attr_accessible :url, :title, :summary

  delegate :name, to: :user, prefix: true

  # Well, this should be improved. Sorry.
  def self.unposted
    where(
      "not
      (
        exists (
          select 1 from posts inner join contents
          on posts.content_id = contents.id
          where contents.link_id = links.id
          and posts.type = 'Posts::Twitter'
        )
        and
        exists (
          select 1 from posts inner join contents
          on posts.content_id = contents.id
          where contents.link_id = links.id
          and posts.type = 'Posts::Facebook'
        )
      )"
    )
  end

  def modifiable_by?(user)
    user.present? && (user.admin? || (!self.contents.exists? && self.user == user))
  end

  def display_name
    title.present? ? title : url_without_protocol
  end

  def error_due_to_duplicate_url?
    errors[:url] == ["has already been taken"]
  end

  def link_with_same_url
    scope = self.class.where(url: url)
    scope = scope.where('id <> ?', id) if id.present?
    scope.first
  end

  def liked_by?(user)
    liked_by_users.exists?(['users.id = ?', user.id])
  end

  def domain
    DomainName.new(url).to_s
  end

  def url_without_protocol
    DomainName.new(url).strip_protocol
  end

  def url=(url)
    self[:url] = Url.new(url).to_s
  end

  private

  def url_present
    errors.add(:url, "can't be blank") if url.split('://').size < 2
  end

  class DomainName < Struct.new(:url)
    def to_s
      strip_protocol
      strip_www
      strip_path
      strip_parameters
      url
    end

    def strip_protocol
      self.url = url.split('//').last
    end

    def strip_www
      self.url = url.sub('www.', '')
    end

    def strip_path
      self.url = url.split('/').first
    end

    def strip_parameters
      self.url = url.split('?').first
    end
  end
end
