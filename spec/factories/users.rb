# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "admin@crespon.com"
    password "password"
    admin true
  end
end
