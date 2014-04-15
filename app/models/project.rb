# A project that the paying company is executing inside Greentime
class Project < ActiveRecord::Base

  belongs_to :company

  attr_accessible :start_date, :name, :active, :deadline, :description

  after_initialize :after_initialize

  validates :company, presence: true
	validates :name, presence: true
	validates :description, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :start_date, presence:true
  validates :deadline, presence: true
  validate :deadline_valid?

  has_many :tasks

  def after_initialize
    self.start_date = Date.today if self.start_date.nil?
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
    ((self.deadline - Date.today) / 7).to_i
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

  # Total hours for the project
  def hours_planned
    hours_planned = 0
    tasks.each do |task|
      hours_planned += task.hours_planned
    end
    hours_planned
  end

  # Hours spent for the project
  def hours_spent
    hours_spent = 0
    tasks.each do |task|
      hours_spent += task.hours_spent
    end
    hours_spent
  end

  # % of hours spent. It can be > 1 if project has override
  def hours_spent_percentage
    return 1 if hours_planned == 0
    (hours_spent.to_f / hours_planned).round(2)
  end
end