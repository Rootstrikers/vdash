FactoryGirl.define do
  factory :user do
  end

  factory :admin, parent: :user do
    admin true
  end
end
