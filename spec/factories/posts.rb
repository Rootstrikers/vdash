FactoryGirl.define do
  factory :post do
    association :content, factory: :twitter_content
    association :user
  end
end
