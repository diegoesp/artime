# Manages the timetable scheme of the GUI by combining both Project Tasks
# and inputs
class TimesheetsController < ApiApplicationController

	before_filter :authenticate_user!

	#
	# Gets the timetable for input
	# Expects date_from as an input
	#
	def index
		render json: Timesheet.all(current_user, Date.parse(params[:date_from]))
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
		render json: Timesheet.update(current_user, params[:date_from], params[:timesheet])
	end

	# Specifies what is the proportion of billable hours for the asked week by
	# a percentage
	#
	# Expects :date_from as an input
	#
	def billable_hours
		date_from = Date.parse(params[:date_from])
		raise "date_from must be a sunday" unless date_from.wday == 0
		render json: Timesheet.billable_hours(date_from, current_user)
	end

	# Returns the list of tasks than the user can pick
	def tasks
		render json: Timesheet.tasks(current_user), each_serializer: TimesheetTaskSerializer
	end
	
end