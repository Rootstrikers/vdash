# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :twitter_content do
    link nil
    user nil
    body "MyText"
  end
end
