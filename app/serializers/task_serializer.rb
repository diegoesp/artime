class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :billable
end