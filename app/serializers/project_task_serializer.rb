class ProjectTaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :hours_planned, :hours_spent, :hours_spent_percentage, :task_id, :project_id

  def name
  	object.task.name
  end
end