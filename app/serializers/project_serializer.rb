class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :weeks_left, :total_weeks, 
  	:weeks_spent_percentage, :hours_spent_percentage, :client_name,
  	:start_date, :deadline, :hours_planned, :active, :client_id,
  	:description

  def client_name
  	object.client.name
  end

  def client_id
  	object.client.id
  end
end