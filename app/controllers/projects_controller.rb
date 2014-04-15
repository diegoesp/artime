# Manages projects
class ProjectsController < ApiApplicationController

	before_filter :is_manager_filter
	
	def index		
		render json: Project.where(active: true)
	end

end