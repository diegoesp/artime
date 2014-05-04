class Plan < ActiveRecord::Base
  attr_accessible :active, :description, :name
  has_many :companies, dependent: :restrict

  validates :name, presence: true
  validates :description, presence: true
end
