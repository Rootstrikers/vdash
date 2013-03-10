FactoryGirl.define do
  factory :link do
    sequence(:url) { |n| "http://www.example.com?number=#{n}" }
    association :user
  end
end
