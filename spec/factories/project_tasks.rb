# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_task do
    hours_planned 1
    deadline "2020-04-18"
    completed false
    billable true
    task
    project
  end
end
