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
  
  attr_accessible :name, :billable, :type

  belongs_to :company

  validates :company, presence: true
	validates :name, presence: true
  validates :name, uniqueness: true
	validates :billable, inclusion: { in: [true, false] }
  validates :type, presence: true

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

end
