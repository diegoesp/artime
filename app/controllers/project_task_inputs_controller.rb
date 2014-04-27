# Manages the timetable scheme of the GUI by combining both Project Tasks
# and inputs
class ProjectTaskInputsController < ApiApplicationController

	before_filter :user_can_see_project_task

	def index
		render json: Input.for_user(current_user, Date.parse(params[:date_from]))
	end

	# Updates the timetable
	# 
	# Expects :id (project_task_id), :input_date and :hours
	def update
		project_task_id = params[:id]
		input = Input.search_by(params, project_task_id, current_user).first
		
		if input.nil?
			input = Input.new
			input.user = current_user
		end

		attributes = params.slice(:input_date, :hours)
		attributes[:project_task_id] = project_task_id
		
		input.update_attributes!(attributes)
		input.save!

		render json: input
	end

	private

	def user_can_see_project_task
		project_task_id = params[:project_task_id]
		return if project_task_id.nil?
		raise "User is not allowed to update this project task" unless project_task.user == current_user
	end
end