FactoryGirl.define do
  factory :post do
    association :content, factory: :content
    association :user
    type 'Post'
  end
end
