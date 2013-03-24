FactoryGirl.define do
  factory :notice do
    association :user
    active false
    body "Site wide notice."
  end
end
