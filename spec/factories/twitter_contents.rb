FactoryGirl.define do
  factory :twitter_content do
    association :link
    association :user
    body "MyText"
  end

  factory :posted_twitter_content, parent: :twitter_content do
    after(:create) { |t| t.posts << Post.new }
  end
end
