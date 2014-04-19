FactoryGirl.define do
  factory :project do
  	client
  	name "Wall-E"
    active true
    deadline "2024-04-13"
    description "A new movie feature from the studios"
  end
end