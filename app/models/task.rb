class Task < ActiveRecord::Base
  belongs_to :project
  attr_accessible :name, :deadline, :hours_planned, :billable

	validates :name, presence: true
	validates :billable, inclusion: { in: [true, false] }
	validates :project, presence: true
  validates :deadline, presence: true
  validates :hours_planned, presence: true
  validates :hours_planned, inclusion: 1..1024

  has_many :inputs

  # Returns hours already spent on this task
  def hours_spent
  	hours_spent = 0
  	inputs.each do |input|
  		hours_spent += input.hours
  	end
  	hours_spent
  end

  # Given a name for a task it find similar tasks for the company
  # and returns them so the GUI can show statistics
  def self.find_similar(name)
  	Task.where("name LIKE ?", "%#{name}%")
  end
end
