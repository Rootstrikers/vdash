class Content < ActiveRecord::Base
  include Likable
  include Deletable

  belongs_to :link
  belongs_to :user

  has_many :posts

  validates :body, presence: true

  attr_accessible :body, :link_id

  delegate :url, :domain, to: :link, prefix: true
  delegate :name, to: :user, prefix: true

  def self.unposted
    where("not exists (select 1 from posts where content_id = contents.id)")
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

  def post!(options = {})
    Poster.new(self, options).run
  end

  def valid_for_twitter?
    true
  end

  private
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
