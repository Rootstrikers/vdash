class CreateTwitterResults < ActiveRecord::Migration
  def change
    create_table :twitter_results do |t|
      t.string :tweet_created_at
      t.string :tweet_from_user
      t.string :tweet_from_user_id
      t.string :tweet_from_user_name
      t.string :tweet_geo
      t.string :tweet_id
      t.string :tweet_iso_language_code
      t.string :tweet_profile_image_url
      t.string :tweet_source
      t.text :tweet_text

      t.timestamps
    end
  end
end
