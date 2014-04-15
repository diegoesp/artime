class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :weeks_left, :total_weeks, :weeks_spent_percentage, :hours_spent_percentage
end