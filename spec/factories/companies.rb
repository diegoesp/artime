FactoryGirl.define do
  factory :company do
  	sequence(:name) { |n| "Salted Apple #{n}" }
    active true
    plan
  end
end
