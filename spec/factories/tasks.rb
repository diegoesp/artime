FactoryGirl.define do
  factory :task do
  	sequence(:name) { |n| "Task #{n}" }
  	billable true
		company
  end
end
