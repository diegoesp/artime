FactoryGirl.define do
  factory :task do
  	name "Illumination"
  	billable true
    project
    hours_planned 40
    deadline "2014-04-16"
  end
end
