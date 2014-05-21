# Manages the timetable scheme of the GUI by combining both Project Tasks
# and inputs
class TimesheetsController < ApiApplicationController

	before_filter :authenticate_user!

	#
	# Gets the timetable for input
	# Expects date_from as an input
	#
	def index
		render json: Timesheet.all(timesheet_user, Date.parse(params[:date_from]))
	end

	#
	# Given a task id, it appoints the task to the project
	#
	def create
		render json: Timesheet.create(timesheet_user, project, task)
	end

	#
	# Gets a single line for the timesheet
	# 
	def show
		render json: Timesheet.get(params[:id])
	end

	# Updates the timetable
	# 
	# Expects the same timetable returned by the index method in JSON format
	# Call http://localhost:3000/api/timesheets?date_from=(last sunday) for a reference
	# "name" fields or other description fields are of course not needed: just the ids and the
	# hours per day
	#
	# Parameters expected are :date_from and :timesheet
	def update
		render json: Timesheet.update(timesheet_user, params[:date_from], params[:timesheet])
	end

	# Specifies what is the proportion of billable hours for the asked week by
	# a percentage
	#
	# Expects :date_from as an input
	#
	def billable_hours
		date_from = Date.parse(params[:date_from])
		raise "date_from must be a sunday" unless date_from.wday == 0
		render json: Timesheet.billable_hours(date_from, timesheet_user)
	end

	# Returns the list of projects than the user can pick
	def projects
		render json: Timesheet.projects(timesheet_user), each_serializer: ProjectSimpleSerializer
	end

	# Returns the list of tasks than the user can pick based on a project
	def tasks
		render json: Timesheet.tasks(project), each_serializer: TimesheetTaskSerializer
	end

	# Returns the list of tasks that are not assigned to a project
	def unassigned_tasks
		render json: Timesheet.unassigned_tasks(project)
	end

	private
	
	# Gets the user whose timesheet is being requested
	def timesheet_user
		if params[:user_id].blank? then
			current_user
		else
			is_manager!
			current_user.company.users.find(params[:user_id])
		end
	end

	# Gets the project stated as a parameter
	def project
		project_id = params[:project_id]
		raise "must specify project_id" if project_id.blank?
		timesheet_user.projects.find(project_id)
	end

	# Gets the task stated as a parameter
	def task
		task_id = params[:task_id]
		raise "must specify task_id" if task_id.blank?
		timesheet_user.company.tasks.find(task_id)
	end

end