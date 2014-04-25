# Manages assignments of users to projects
class ProjectUsersController < ApiApplicationController

	before_filter :is_manager_filter

	# Returns a CSV of the selected users for the project
	#
	# Expects a project_id to gather the info
	def index
		render json: Project.find(params[:project_id]).users.map { |user| user.id }.join(",").to_json
	end

	# Expects two params
	#
	# project_id: the project being updated
	# user_id_csv: a comma separated list of users with the assigned users
	#
	# Any pre-existing assigned users are erased and the list is updated
	# with this new list
	def update
		user_id_array = params[:user_id_csv].split(",")
		
		project = Project.find(params[:project_id])
		project.users = []
		user_id_array.each do |user_id|
    	project.users << User.find(user_id)
    end
    project.save!

    render json: project.users
	end

end