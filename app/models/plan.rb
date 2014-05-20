# == Schema Information
#
# Table name: plans
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  active      :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Plan < ActiveRecord::Base
  attr_accessible :active, :description, :name
  has_many :companies, dependent: :restrict

  validates :name, presence: true
  validates :description, presence: true
end
