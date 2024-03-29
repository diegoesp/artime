# == Schema Information
#
# Table name: project_tasks
#
#  id            :integer          not null, primary key
#  hours_planned :integer
#  deadline      :date
#  completed     :boolean          default(FALSE), not null
#  task_id       :integer
#  project_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ProjectTask < ActiveRecord::Base

	belongs_to :project
  belongs_to :task

	validates :completed, inclusion: { in: [true, false] }
	validates :project, presence: true
  validates :hours_planned, presence: true
  validates :hours_planned, inclusion: 0..1024

  validate :company_task_consistent

  attr_accessible :completed, :deadline, :hours_planned, :project_id, :task_id

  has_many :inputs, dependent: :restrict

  after_initialize :after_initialize
  def after_initialize
    self.completed = false if self.completed.nil?
    self.hours_planned = 0 if self.hours_planned.nil?
  end

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
    return if self.project.nil?
    return if self.project.client.company.tasks.include?(self.task)
    errors.add(:task, "must belong to the stated company")
  end

  # Returns the list of project tasks for a given user
  def self.for_user(user, date_from)
    project_tasks = []

    date_to = date_from + 6.days

    # Return only those where the user has already input hours
    where = "projects.active = true AND (inputs.user_id = #{user.id} AND inputs.input_date >= '#{date_from}' AND inputs.input_date <= '#{date_to}')"
    ProjectTask.joins(:inputs).joins(:project).where(where).uniq.each do |project_task|
      project_tasks << project_task
    end

    project_tasks
  end

end
