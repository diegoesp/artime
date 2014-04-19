# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :input do
    project_task
    user
    input_date "2024-04-13"
    hours 8
  end
end
