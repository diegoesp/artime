# A paying customer for Greentime
class Company < ActiveRecord::Base
  attr_accessible :active, :name

  validates :active, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :name, length: { maximum: 50 }

  has_many :roles
end
