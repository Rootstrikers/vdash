FactoryGirl.define do
  factory :twitter_content do
    association :link
    association :user
    body "MyText"
  end
end
