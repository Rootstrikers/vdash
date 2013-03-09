# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    content_id 1
    content_type "MyString"
    user nil
  end
end
