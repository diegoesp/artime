# Manages Tasks
class RegularTasksController < TasksController

	before_filter :is_manager!

	# Gets a special report stating the last projects that used
	# a specific task and how much was estimated and spent
	def last_projects_report
		render json: RegularTask.find(params[:id]).last_projects_report
	end

end