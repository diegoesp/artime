# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :input do
    project_task
    input_date "2024-04-13"
    hours 8

    after(:build) do |input|
    	input.user = create(:user, company: input.project_task.task.company) if input.user.nil?
    	input.project_task.project.users << input.user
    end
  end
end
