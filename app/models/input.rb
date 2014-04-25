# Work entered by a user for a task
class Input < ActiveRecord::Base
  belongs_to :project_task
  belongs_to :user
  
  attr_accessible :hours, :input_date

  validates :project_task, presence: true
  validates :user, presence: true
  validates :hours, inclusion: 1..24
  validates :input_date, presence: true
end
