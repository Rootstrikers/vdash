# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :facebook_content do
    link nil
    user nil
    body "MyText"
  end
end
