FactoryGirl.define do
  factory :regular_task do
  	sequence(:name) { |n| "Regular Task #{n}" }
  	billable true
		company
  end
end