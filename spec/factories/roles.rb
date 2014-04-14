FactoryGirl.define do
  factory :role do
    code Role::DEVELOPER
    user
    company
  end
end
