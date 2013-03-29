FactoryGirl.define do
  factory :facebook_content do
    association :link
    association :user
    body "MyText"
  end

  factory :posted_facebook_content, parent: :facebook_content do
    after(:create) { |t| t.posts << Post.new }
  end
end
