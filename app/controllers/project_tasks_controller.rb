# Manages Project Tasks
class ProjectTasksController < ApiApplicationController

	before_filter :can_user_see_project

	def index
		render json: Project.find(params[:project_id]).project_tasks
	end

	def create
		project_task = ProjectTask.new(params[:project_task])
		project_task.project_id = params[:project_id]
    project_task.save!
    render json: project_task
	end

	def update
    project_task = Project.find(params[:project_id]).project_tasks.find(params[:id])
    project_task.update_attributes!(params[:project_task])
    render json: project_task
  end

  def destroy
    project_task = Project.find(params[:project_id]).project_tasks.find(params[:id])
    render json: project_task.destroy
  end

	private

	def can_user_see_project
		project = Project.find(params[:project_id])
		raise "Project does not exist" if project.nil?
		raise "User has no access to this project" unless project.has_user?(current_user) or current_user.manager?
	end
end