FactoryGirl.define do
  factory :click do
    association :user
    association :item
  end
end
