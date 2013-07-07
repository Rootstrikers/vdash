# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :linked_account do
    user nil
    uid "MyString"
    provider "MyString"
  end
end
