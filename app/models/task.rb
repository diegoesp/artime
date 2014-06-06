# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  billable   :boolean          default(TRUE), not null
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)      default("RegularTask"), not null
#

class Task < ActiveRecord::Base
  
  attr_accessible :name, :billable

  belongs_to :company

  validates :company, presence: true
	validates :name, presence: true
  validates_uniqueness_of :name, :scope => :company_id
	validates :billable, inclusion: { in: [true, false] }

  has_many :project_tasks, dependent: :restrict

  def average_spent_hours
    hours_spent = 0
    project_tasks.each do |project_task|
      project_task.inputs.each do |input|
        hours_spent += input.hours
      end
    end
    hours_spent / project_tasks.length
  end

  def average_planned_hours
    hours_planned = 0
    project_tasks.each do |project_task|
      hours_planned += project_task.hours_planned
    end
    hours_planned / project_tasks.length
  end

  # Returns a structure reporting how much time was estimated for
  # this task in the last 5 projects and how much time was really
  # spent
  def last_projects_report
    last_projects_report = []

    # Get last projects tasks
    project_tasks = ProjectTask.where("project_tasks.task_id = #{self.id}").order("project_id DESC").limit(5)
    project_tasks.each do |project_task|
      # Now extract the info for the report
      row = LastProjectsReportRow.new
      row.project_id = project_task.project.id
      row.project_name = project_task.project.name
      row.hours_planned = project_task.hours_planned
      row.hours_spent = project_task.hours_spent

      last_projects_report << row
    end

    last_projects_report
  end

  # Used for generating the report in last_projects_report
  class LastProjectsReportRow
    attr_accessor :project_id
    attr_accessor :project_name
    attr_accessor :hours_planned
    attr_accessor :hours_spent
  end

end