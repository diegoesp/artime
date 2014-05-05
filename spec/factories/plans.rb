# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    name "Plan"
    description "Plan desc"
    active true
  end
end
