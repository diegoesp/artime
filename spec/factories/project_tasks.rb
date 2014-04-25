# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_task do
    hours_planned 1
    deadline "2020-04-18"
    completed false
    billable true
    project

		after(:build) do |project_task|
      project_task.task  = FactoryGirl.create(:task, company: project_task.project.client.company) if project_task.task.nil?
    end

  end
end
