# Work entered by a user for a task
class Input < ActiveRecord::Base
  belongs_to :project_task
  belongs_to :user
  
  attr_accessible :hours, :input_date, :project_task_id

  validates :project_task, presence: true
  validates :user, presence: true
  validates :hours, inclusion: 1..24
  validates :input_date, presence: true

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

  # Construct necessary info to construct a calendar for the user
  # to input hours per day for an specific project task.
  #
  # Returns an array of UserInputRow. Each position of the array
  # should be shown in a timetable. 
  #
  # Method asks for a user (to get the grid for him) and a date_from that must
  # be always Sunday. Period is always 7 days (a whole week) so no date_to is needed.
  def self.for_user(user, date_from)
  	raise "date_from must be sunday" unless date_from.wday == 0
  	project_tasks = ProjectTask.for_user(user)
  	userInputHash = Hash.new
  	project_tasks.each do |project_task|
  		userInputHash[project_task.id] = UserInputRow.new(project_task) unless userInputHash.has_key?(project_task.id)

			inputs = project_task.inputs.where("user_id = #{user.id} AND input_date >= '#{date_from}' AND input_date <= '#{date_from + 6}'")

			inputs.each do |input|
				userInputHash[project_task.id].add_hours(input.input_date.wday, input.hours)
			end
  	end

  	userInputHash.values
  end

  # Used for for_user method
  class UserInputRow
    attr_accessor :project_task_id
  	attr_accessor :project_name
    attr_accessor :task_name
  	
  	attr_accessor :sun
  	attr_accessor :mon
  	attr_accessor :tue
  	attr_accessor :wed
  	attr_accessor :thu
  	attr_accessor :fri
  	attr_accessor :sat

  	def initialize(project_task)
      self.project_task_id = project_task.id
  		self.project_name = project_task.project.name
      self.task_name = project_task.task.name

  		self.sun = 0
  		self.mon = 0
  		self.tue = 0
  		self.wed = 0
  		self.thu = 0
  		self.fri = 0
  		self.sat = 0
  	end

  	def add_hours(day, hours)
      raise "day #{day} is not correct. Must be between 0 and 6" if day < 0 or day > 6

  		self.sun += hours if day == 0
  		self.mon += hours if day == 1
  		self.tue += hours if day == 2
  		self.wed += hours if day == 3
  		self.thu += hours if day == 4
  		self.fri += hours if day == 5
  		self.sat += hours if day == 6
  	end
  end
end