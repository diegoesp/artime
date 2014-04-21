class ProjectTaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :hours_planned, :hours_spent, :hours_spent_percentage

  def name
  	object.task.name
  end
end