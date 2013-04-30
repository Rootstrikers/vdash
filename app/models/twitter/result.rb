module Twitter
  class Result < ActiveRecord::Base
    attr_accessible :tweet_created_at, :tweet_from_user, :tweet_from_user_id, :tweet_from_user_name,
      :tweet_geo, :tweet_id, :tweet_iso_language_code, :tweet_profile_image_url, :tweet_source, :tweet_text

    def self.from_json(json)
      return if exists?(tweet_id: json['id'])

      create(
        tweet_created_at:        json['created_at'],
        tweet_from_user:         json['from_user'],
        tweet_from_user_id:      json['from_user_id'],
        tweet_from_user_name:    json['from_user_name'],
        tweet_geo:               json['geo'],
        tweet_id:                json['id'],
        tweet_iso_language_code: json['iso_language_code'],
        tweet_profile_image_url: json['profile_image_url'],
        tweet_source:            json['source'],
        tweet_text:              json['text']
      )
    end
  end
end
