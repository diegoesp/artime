class ProjectTaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :hours_planned, :hours_spent, :hours_spent_percentage, :task_id, :project_id, :project_name

  def name
  	object.task.name
  end

  def project_name
  	object.project.name
  end
end