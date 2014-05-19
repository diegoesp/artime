# Manages Tasks
class TasksController < ApiApplicationController

	before_filter :is_manager!

	def index
		render json: current_user.company.tasks.where(type: params[:type]).order("name"), each_serializer: TaskSerializer
	end
	
	def create
		task = Task.new(params[:task].except(:company_id))
		task.company = current_user.company
		task.save!
		render json: task, serializer: TaskSerializer
	end

	def update
		task = current_user.company.tasks.find(params[:id])
		task.update_attributes!(params[:task].except(:company_id))
		render json: task, serializer: TaskSerializer
	end

	def destroy
		render json: current_user.company.tasks.find(params[:id]).destroy, serializer: TaskSerializer
	end

	# Gets a special report stating the last projects that used
	# a specific task and how much was estimated and spent
	def last_projects_report
		render json: Task.find(params[:id]).last_projects_report
	end

end