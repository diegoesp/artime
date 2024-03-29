FactoryGirl.define do
  factory :user do
  	sequence(:username) { |n| "jlasseter#{n}" }
  	first_name "John"
  	last_name "Lasseter"
    sequence(:email) { |n| "email#{n}@domain.com" }
    password "password"
    admin true
    company
    role_code Role::DEVELOPER
  end
end
