# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  active      :boolean
#  deadline    :date
#  description :string(255)
#  client_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string(255)
#  start_date  :date
#

# A project that the paying company is executing inside our SASS
class Project < ActiveRecord::Base

  belongs_to :client

  attr_accessible :start_date, :name, :active, :deadline, :description, :client_id, :internal

  validates :client, presence: true
	validates :name, presence: true
  validates :name, length: { maximum: 30 }
	validates :description, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :internal, inclusion: { in: [true, false] }
  validates :start_date, presence:true
  validates :deadline, presence: true
  validate :deadline_valid?

  has_many :project_tasks, dependent: :restrict

  has_and_belongs_to_many :users

  after_initialize :after_initialize
  after_save :after_save

  def after_initialize
    self.start_date = Date.today if self.start_date.nil?
    self.active = true if self.active.nil?
    self.internal = false if self.internal.nil?
  end

  def after_save
    if self.internal then
      # If an internal project, it must include all users
      self.client.company.users.each do |user|
        user.assign_to_internal_projects
      end
    end
  end

  # Prevents deadline from being before today
  def deadline_valid?
    return if self.deadline.nil?

  	if self.deadline < Date.today then
  		errors.add(:deadline, "Deadline cannot be before today");
  	end
  end

  # How many weeks do we have left until deadline is reached ?
  def weeks_left
    date = Date.today
    date = self.start_date if self.start_date > Date.today
    ((self.deadline - date) / 7).to_i
  end

  # The duration of the project expressed in weeks
  def total_weeks
    ((self.deadline - self.start_date) / 7).to_i
  end

  # % of total weeks spent
  def weeks_spent_percentage
    return 0 if self.total_weeks == 0
    (1 - (weeks_left.to_f / total_weeks)).round(2)
  end

  # Total planned hours for the project based on the tasks scheduled
  def hours_planned
    hours_planned = 0
    project_tasks.each do |project_task|
      hours_planned += project_task.hours_planned
    end
    hours_planned
  end

  # Hours spent for the project
  def hours_spent
    hours_spent = 0
    project_tasks.each do |project_task|
      hours_spent += project_task.hours_spent
    end
    hours_spent
  end

  # % of hours spent. It can be > 1 if project has override
  def hours_spent_percentage
    return 1 if hours_planned == 0
    (hours_spent.to_f / hours_planned).round(2)
  end

  # Allows to search by pre-defined params. All are optional.
  #
  # client: by client_id
  # active: if true, only gets active projects
  # name: name of the project as a like
  # internal: if the project is internal
  def self.search_by(params, user)
    conditions = []
    arguments = Hash.new

    conditions << "company_id = :company"
    arguments[:company] = user.company.id

    unless params[:client].blank?
      conditions << "client_id = :client"
      arguments[:client] = params[:client]
    end

    unless params[:active].blank?
      conditions << "projects.active = :active"
      arguments[:active] = params[:active]
    end

    unless params[:internal].nil?
      conditions << "projects.internal = :internal"
      arguments[:internal] = params[:internal]
    end

    unless params[:name].blank?
      conditions << "lower(projects.name) LIKE lower(:name)"
      arguments[:name] = "%#{params[:name]}%"
    end

    unless params[:date].blank?
      conditions << "(start_date <= :date AND deadline >= :date)"
      arguments[:date] = params[:date]
    end

    conditions_joined = conditions.join(" AND ")
    Project.joins(:client).joins(client: :company).find(:all, conditions: [conditions_joined, arguments])
  end

  # The user has access to this project?
  def has_user?(user)
    self.users.include?(user)
  end

  # Checks if this project has the task
  def has_task?(task)
    self.project_tasks.each do |project_task|
      return true if project_task.task == task
    end
    false
  end
end
