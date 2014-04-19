class Task < ActiveRecord::Base
  
  attr_accessible :name

  belongs_to :company

  validates :company, presence: true
	validates :name, presence: true
	validates :billable, inclusion: { in: [true, false] }

  has_many :project_tasks

  def average_planned_hours
    hours_planned = 0
    project_tasks.each do |project_task|
      hours_planned += project_task.hours_planned
    end
    hours_planned / project_tasks.length
  end

  def average_spent_hours
    hours_spent = 0
    project_tasks.each do |project_task|
      project_task.inputs.each do |input|
        hours_spent += input.hours
      end
    end
    hours_spent / project_tasks.length
  end
end
