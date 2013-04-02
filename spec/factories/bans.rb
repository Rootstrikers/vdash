FactoryGirl.define do
  factory :ban do
    association :user
    association :created_by, factory: :user
    created_at "2013-04-01 22:34:26"
    reason "MyText"
  end
end
