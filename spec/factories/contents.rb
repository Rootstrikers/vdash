FactoryGirl.define do
  factory :content do
    association :link
    association :user
    body "MyText"
  end

  factory :posted_content, parent: :content do
    after(:create) { |t| t.posts << Post.new }
  end

  factory :posted_twitter_content, parent: :content do
    after(:create) { |t| t.posts << Posts::Twitter.new }
  end

  factory :posted_facebook_content, parent: :content do
    after(:create) { |t| t.posts << Posts::Facebook.new }
  end
end
