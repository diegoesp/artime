# Manages users
class UsersController < ApiApplicationController

	before_filter :is_manager_filter

	def index
		render json: User.all
	end

end