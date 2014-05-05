class TimesheetTaskSerializer < ActiveModel::Serializer
	attributes :id, :name
  def name
  	"#{object.project.name} - #{object.task.name}"
  end
end