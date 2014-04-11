# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :administration1, :class => Administration do
    name "Administracion Blum SRL"
	end

	factory :administration2, :class => Administration do
		name "Administracion de consorcios SA"
	end

end
