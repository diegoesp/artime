FactoryGirl.define do
  factory :global_task do
  	sequence(:name) { |n| "Task #{n}" }
		company
  end
end
