# A client for the company
class Client < ActiveRecord::Base
  belongs_to :company
  has_many :projects

  attr_accessible :name

  validates :name, presence: true
end
