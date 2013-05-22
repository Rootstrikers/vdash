module Twitter
  class Result < ActiveRecord::Base
    belongs_to :content
    belongs_to :link

    attr_accessible :tweet_created_at, :tweet_from_user, :tweet_from_user_id, :tweet_from_user_name,
      :tweet_geo, :tweet_id, :tweet_iso_language_code, :tweet_profile_image_url, :tweet_source, :tweet_text,
      :content, :link

    def self.unpublished
      where(content_id: nil)
    end

    def self.extract_url(text)
      URI.extract(text).select { |link| link =~ /^http/ }.first
    end

    def self.from_json(json)
      return if extract_url(json['text']).blank? or !Url.new(extract_url(json['text'])).valid?
      return find_by_tweet_id(json['id'].to_s) if exists?(tweet_id: json['id'].to_s)

      create(
        tweet_created_at:        json['created_at'],
        tweet_from_user:         json['from_user'],
        tweet_from_user_id:      json['from_user_id'],
        tweet_from_user_name:    json['from_user_name'],
        tweet_geo:               json['geo'],
        tweet_id:                json['id'].to_s,
        tweet_iso_language_code: json['iso_language_code'],
        tweet_profile_image_url: json['profile_image_url'],
        tweet_source:            json['source'],
        tweet_text:              json['text']
      )
    end

    def url
      @url ||= self.class.extract_url(tweet_text)
    end

    def content_body
      url.present? ? tweet_text.gsub(url, '').gsub(/\s\s+/, ' ') : tweet_text
    end

    def unpublished?
      content_id.nil?
    end
  end
end
