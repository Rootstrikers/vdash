class Content < ActiveRecord::Base
  TWITTER_LENGTH_LIMIT = 120

  include Likable
  include Deletable

  belongs_to :link
  belongs_to :user

  has_many :posts, dependent: :destroy

  validates :body, presence: true
  validate :can_add_content_to_link, on: :create

  attr_accessible :body, :link, :link_id

  delegate :url, :domain, to: :link, prefix: true
  delegate :name, to: :user, prefix: true

  # TODO: Need to enable filtering to things that have not been posted to all places they are eligible
  # (The below won't work since some things aren't eligible for posting to Twitter, so they'd never match.)
  # def self.unposted
  #   where("not (
  #     exists (
  #       select 1 from posts where content_id = contents.id and type = :facebook_type
  #     )
  #     and
  #     exists (
  #       select 1 from posts where content_id = contents.id and type = :twitter_type
  #     )
  #   )", {
  #     facebook_type: 'Posts::Facebook',
  #     twitter_type:  'Posts::Twitter'
  #   })
  # end

  def self.unposted
    where('not exists (select 1 from posts where content_id = contents.id)')
  end

  def self.posted
    joins(:posts)
  end

  def self.posted_to_twitter
    posted.merge(Post.twitter)
  end

  def self.posted_to_facebook
    posted.merge(Post.facebook)
  end

  def self.newest_post_first
    posted.merge(Post.newest_first)
  end

  def link
    Link.unscoped { super }
  end

  def post!(options = {})
    Poster.new(self, options).run
  end

  def valid_for_twitter?
    body.length <= TWITTER_LENGTH_LIMIT
  end

  private

  def can_add_content_to_link
    unless link.nil? or link.can_add_content?(User.current)
      errors[:base] << "A link can only have #{Link::MAX_CONTENTS} post suggestions, and only #{Link::MAX_CONTENTS_PER_USER} per user."
    end
  end

  class Poster < Struct.new(:content, :options)
    def run
      ensure_valid_options
      create_post
    end

    def ensure_valid_options
      raise "#{options[:service] || 'That'} is an invalid service." unless [:twitter, :facebook].include? options[:service]
    end

    def create_post
      User.current.posts << post_class.create(content: content)
    end

    def post_class
      case options[:service]
      when :facebook then Posts::Facebook
      when :twitter  then Posts::Twitter
      end
    end
  end
end
