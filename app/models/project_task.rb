class ProjectTask < ActiveRecord::Base

	belongs_to :project
  belongs_to :task

	validates :completed, inclusion: { in: [true, false] }
	validates :billable, inclusion: { in: [true, false] }
	validates :project, presence: true
  validates :deadline, presence: true
  validates :hours_planned, presence: true
  validates :hours_planned, inclusion: 1..1024

  validate :company_task_consistent

  attr_accessible :completed, :deadline, :hours_planned, :billable, :project_id, :task_id

  has_many :inputs

	# Returns hours already spent on this task
  def hours_spent
  	hours_spent = 0
  	inputs.each do |input|
  		hours_spent += input.hours
  	end
  	hours_spent
  end

  # Returns percentage of hours spent against estimation
  def hours_spent_percentage
    return 1 if hours_planned == 0
    (hours_spent.to_f / hours_planned).round(2)
  end

  # The task must belong to the stated company
  def company_task_consistent
    return if self.project.client.company.tasks.include?(self.task)
    errors.add(:task, "must belong to the stated company")
  end
end
