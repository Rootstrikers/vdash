# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    item_id 1
    item_type "MyString"
    user nil
  end
end
