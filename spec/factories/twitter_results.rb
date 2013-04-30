FactoryGirl.define do
  factory :twitter_result, :class => 'Twitter::Result' do
    tweet_created_at "MyString"
    tweet_from_user "MyString"
    tweet_from_user_id "MyString"
    tweet_from_user_name "MyString"
    tweet_geo "MyString"
    tweet_id "MyString"
    tweet_iso_language_code "MyString"
    tweet_profile_image_url "MyString"
    tweet_source "MyString"
    tweet_text "MyText"
    association :link
    association :content
  end
end
