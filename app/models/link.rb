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

  MAX_CONTENTS          = 10
  MAX_CONTENTS_PER_USER = 2

  belongs_to :user
  has_many :contents, dependent: :destroy

  validates :url, uniqueness: true, presence: true
  validate :url_valid

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

  def self.not_system
    joins(:user).where('users.provider <> ?', 'system')
  end

  def can_add_content?(user)
    can_have_more_contents? and user_can_create_content?(user)
  end

  def can_have_more_contents?
    contents.count < MAX_CONTENTS
  end

  def user_can_create_content?(user)
    return true if user.nil? and Rails.env.test? # I'm sorry. FIXME
    return false if user.nil?
    contents.where(user_id: user.id).count < MAX_CONTENTS_PER_USER
  end

  def top_contents(limit = 3)
    contents.ordered.limit(limit)
  end

  def modifiable_by?(user)
    user.present? && (user.admin? || (!self.contents.exists? && self.user == user))
  end

  def display_name
    if title.present?
      "#{ellipsize(title)} (from #{domain})"
    else
      ellipsize(url_without_protocol)
    end
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

  def url_valid
    errors[:url] << "looks like it's not quite right." unless Url.new(url).valid?
  end

  def ellipsize(str)
    if str.size > 40
      str[0..37] + "..."
    else
      str
    end
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
