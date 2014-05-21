# Logical representation of a timesheet. Not persistent.
#
# This class abstracts complexity for Input and ProjectTask: based on these
# two classes it creates a full timesheet (through the method get) and
# updates the timesheet (through the method update). A timesheet is
# always 7 days, goes from sunday to saturday and is generated for a
# specific user
class Timesheet

  # Construct necessary info to construct a calendar for the user
  # to input hours per day for an specific project task.
  #
  # Returns an array of UserInputRow. Each position of the array
  # should be shown in a timetable.
  #
  # Method asks for a user (to get the grid for him) and a date_from that must
  # be always Sunday. Period is always 7 days (a whole week) so no date_to is needed.
  def self.all(user, date_from)
  	
    raise "date_from must be sunday" unless date_from.wday == 0
  	
    project_tasks = ProjectTask.for_user(user, date_from)
  	 
    # Collect the project task week inputs here
    hash = Hash.new

  	project_tasks.each do |project_task|
  		hash[project_task.id] = ProjectTaskWeekInput.new(project_task) unless hash.has_key?(project_task.id)

			inputs = project_task.inputs.where("user_id = #{user.id} AND input_date >= '#{date_from}' AND input_date <= '#{date_from + 6}'").uniq

			inputs.each do |input|
				hash[project_task.id].add_hours(input.input_date.wday, input.hours)
			end
  	end

  	hash.values
  end

  # Assigns a task to the project and returns the timesheet for it
  # Expects a user (the one that added the task), the project and the
  # task so I can link them together
  def self.create(user, project, task)
    project_task = ProjectTask.new()
    project_task.project = project
    project_task.task = task
    project_task.save!

    # Timesheet.mail_task_added(project_task, user)
    
    ProjectTaskWeekInput.new(project_task)
  end

  # Sends a notification to manager users reporting that a user added a task
  def self.mail_task_added(project_task, adder_user)
    User.where("role_code = #{Role::MANAGER}").each do |manager_user|
      TimesheetMailer.mail_task_added(project_task, adder_user, manager_user).deliver
    end
  end

  # Saves the updated timesheet for a given user and 7 days range
  # See get_timesheet_for_user
  def self.update(user, date_from, timesheet)

    # Take each timesheet item. Then, for each one, take a weekday.
    # Then, for every weekday, check the input hours and update it
    # in the database
    timesheet.each do |project_task_week_input|
      # I have to take into account if the caller sends a hash or an object
      project_task_id = project_task_week_input.id if project_task_week_input.respond_to?(:id)
      project_task_id = project_task_week_input["id"] if project_task_week_input.respond_to?(:keys)
      # Inspect each day
      week_input = project_task_week_input.week_input if project_task_week_input.respond_to?(:week_input)
      week_input = project_task_week_input["week_input"] if project_task_week_input.respond_to?(:keys)
      week_input.keys.each do |day|
        # Get the input_date for this day
        input_date = Date.parse(date_from.to_s) + day.to_i

        # If the input is zero, then just delete any pre-existing inputs (most of the time this will be the case)
        hours = week_input[day].to_i
        # This 'where' locates inputs based on the present data
        where = "input_date = '#{input_date}' AND user_id = #{user.id} AND project_task_id = #{project_task_id}"
        if hours == 0 then
          Input.delete_all(where)
        else
          # If I have other input than zero, then I check if the input changes the
          # value. If it doesn't, then I simply do nothing. If it does, then
          # I delete all the inputs and create a new one
          present_hours = Input.where(where).sum(:hours)

          unless present_hours == hours then
            Input.delete_all(where)
            input = Input.new(input_date: input_date, project_task_id: project_task_id, hours: hours)
            input.user = user
            input.save!
          end # unless
        end # if hours
      end # week_input.keys
    end # timesheet.each
  end

  # Gets a sigle line of timesheet. Expects the project task id
  def self.get(id)
    ProjectTaskWeekInput.new(ProjectTask.find(id))
  end

  #
  # Gets the % of billable hours were entered for a week (40 hours)
  #
  def self.billable_hours(date_from, user)
    date_to = date_from + 6
    conditions = "tasks.billable = true AND input_date >= '#{date_from}' AND input_date <= '#{date_to}' AND user_id = #{user.id}"
    hours = Input.joins(:project_task).joins(project_task: :task).sum(:hours, conditions: conditions)
    
    percentage = (hours / 40.0).round(2)
    percentage = 1 if (percentage > 1)
    percentage
  end

  # This is just a DTO for transferring info
  class ProjectTaskWeekInput
    attr_accessor :id
  	attr_accessor :project_name
    attr_accessor :task_name
  	attr_accessor :week_input

  	def initialize(project_task)      
      self.id = project_task.id
      self.week_input = { "0" => 0, "1" => 0, "2" => 0, "3" => 0, "4" => 0, "5" => 0, "6" => 0}

      self.project_name = project_task.project.name
      self.task_name = project_task.task.name
  	end

  	def add_hours(day, hours)
      raise "day #{day} is not correct. Must be between 0 and 6" if day < 0 or day > 6
  		self.week_input[day.to_s] += hours
  	end
  end

  def self.projects(user)
    # Ensure that the user has access to all internal projects
    user.assign_to_internal_projects
    user.projects.uniq
  end

  # Project tasks available to fill in the timesheet (included in the project)
  def self.tasks(project)
    project.project_tasks.includes(:task).uniq.order("tasks.name")
  end

  # Tasks that are not assigned to the project
  def self.unassigned_tasks(project)
    unassigned_tasks = []
    Task.all.each do |task|
      unassigned_tasks << task unless project.has_task?(task)
    end
    unassigned_tasks
  end

end