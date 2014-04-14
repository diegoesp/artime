# A role for a user in Greentime
class Role < ActiveRecord::Base

  attr_accessible :code, :company, :user

  belongs_to :company
  belongs_to :user

  validates :company, presence: true
  validates :user, presence: true

  DEVELOPER = 10
  MANAGER = 20
  COMPANY = 30
  GOD = 40
  
  CODES = [DEVELOPER, MANAGER, COMPANY, GOD]

  validates :code, inclusion: { in: CODES }
  
  def self.codes
  	CODES
  end

end