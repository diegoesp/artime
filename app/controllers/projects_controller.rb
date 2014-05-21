# Manages projects
class ProjectsController < ApiApplicationController

	before_filter :is_manager!
	before_filter :can_user_see_client, except: [:index, :destroy]

	def index
		params[:active] = true if params[:active].nil?
		params[:internal] = false
		render json: Project.search_by(params, current_user)
	end

	def create
		project = Project.new(params[:project])
		project.save!
		render json: project
	end

	def update
		project = Project.find(params[:id])
		project.update_attributes!(params[:project])
		render json: project
	end

	def destroy
		project = Project.find(params[:id])
		render json: project.destroy
	end

	def show
		render json: Project.find(params[:id]);
	end
  
	private

	def can_user_see_client
		return if params[:client_id].blank?
		raise "User has no access to this client" unless Client.find(params[:client_id]).company.has_user?(current_user)
	end
end