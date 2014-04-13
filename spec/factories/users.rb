FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@domain.com" }
    password "password"
    admin true
  end
end
