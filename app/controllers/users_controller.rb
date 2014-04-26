# Manages users
class UsersController < ApiApplicationController

	before_filter :is_manager_filter

	def index
		render json: User.all
	end

	def update
	    user = User.find(params[:id])
		user.update_attributes!(params[:user])
	    render json: user
	end

end