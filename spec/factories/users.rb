FactoryGirl.define do
  factory :user do
  	first_name "John"
  	last_name "Lasseter"
    sequence(:email) { |n| "email#{n}@domain.com" }
    password "password"
    admin true
  end
end
