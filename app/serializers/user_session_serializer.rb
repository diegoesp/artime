class UserSessionSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :manager

  def manager
  	object.manager?
  end
end