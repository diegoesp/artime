# == Schema Information
#
# Table name: inputs
#
#  id              :integer          not null, primary key
#  project_task_id :integer
#  user_id         :integer
#  input_date      :date
#  hours           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Work entered by a user for a task
class Input < ActiveRecord::Base
  
  belongs_to :project_task
  belongs_to :user
  
  attr_accessible :hours, :input_date, :project_task_id

  validates :project_task, presence: true
  validates :user, presence: true
  validates :hours, inclusion: 1..24
  validates :input_date, presence: true

  #
  # Allows to search by input_date, project_task_id and user
  #
  def self.search_by(params, project_task_id, user)
    conditions = []
    arguments = Hash.new

    conditions << "user_id = :user_id"
    arguments[:user_id] = user.id

    conditions << "project_task_id = :project_task_id"
    arguments[:project_task_id] = project_task_id

    unless params[:input_date].blank?
      conditions << "input_date = :input_date"
      arguments[:input_date] = params[:input_date]
    end
    
    conditions_joined = conditions.join(" AND ")
    Input.find(:all, conditions: [conditions_joined, arguments])
  end
  
end
