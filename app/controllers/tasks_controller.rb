# Manages Tasks
class TasksController < ApiApplicationController

	def index
		render json: current_user.company.tasks.order("name")
	end
	
end