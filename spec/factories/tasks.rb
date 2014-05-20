FactoryGirl.define do
  factory :task do
  	sequence(:name) { |n| "Task #{n}" }
  	billable true
  	type "RegularTask"
		company
  end
end