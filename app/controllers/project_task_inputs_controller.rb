# Manages the timetable scheme of the GUI by combining both Project Tasks
# and inputs
class ProjectTaskInputsController < ApiApplicationController

	before_filter :user_can_see_project_task

	#
	# Gets the timetable for input
	# Expects date_from as an input
	#
	def index
		render json: Input.for_user(current_user, Date.parse(params[:date_from]))
	end

	# Updates the timetable
	# 
	# Expects :id (project_task_id), :input_date and :hours
	def update
		project_task_id = params[:id]
		input = Input.search_by(params, project_task_id, current_user).first
		# If there's no input for update, create one to store the new hours
		input = Input.new if input.nil?
			
		input.user = current_user
		input.project_task_id = project_task_id
		input.input_date = params[:input_date]
		input.hours = params[:hours]

		if (input.hours == 0) then
			# Input should not exist. Just destroy if stored
			input.destroy unless input.id.nil?
		else
			input.save!		
		end
		
		render json: input
	end

	# Specifies what is the proportion of billable hours for the asked week by
	# a percentage
	#
	# Expects :date_from as an input
	#
	def billable_hours
		date_from = Date.parse(params[:date_from])
		raise "date_from must be a sunday" unless date_from.wday == 0
		render json: Input.billable_hours(date_from, current_user)
	end

	private

	def user_can_see_project_task
		project_task_id = params[:project_task_id]
		return if project_task_id.nil?
		raise "User is not allowed to update this project task" unless project_task.user == current_user
	end
end