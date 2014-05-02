class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :input_completed_percentage

  has_many :users_with_pending_input, serializer: UserSerializer
end