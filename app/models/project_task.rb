class ProjectTask < ActiveRecord::Base

	belongs_to :project
  belongs_to :task

	validates :completed, inclusion: { in: [true, false] }
	validates :billable, inclusion: { in: [true, false] }
	validates :project, presence: true
  validates :deadline, presence: true
  validates :hours_planned, presence: true
  validates :hours_planned, inclusion: 1..1024

  attr_accessible :completed, :deadline, :hours_planned, :billable

  has_many :inputs

	# Returns hours already spent on this task
  def hours_spent
  	hours_spent = 0
  	inputs.each do |input|
  		hours_spent += input.hours
  	end
  	hours_spent
  end

end
