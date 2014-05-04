# Manages users
class UsersController < ApiApplicationController

	before_filter :authenticate_user! 
	before_filter :is_manager_filter, only: [:new] 
	before_filter :can_user_see_user, except: [:index, :create]

	def index
		render json: User.where(company_id: current_user.company)
	end

	def show
		user_id = (params[:id] == "me") ? current_user.id : params[:id]
		render :json => User.find(user_id)
	end

	def update
		user_id = (params[:id] == "me") ? current_user.id : params[:id]
		user = User.find(user_id)
		raise "You don't have access to this user" unless user == current_user || current_user.manager?
		# Remove avatar attribute. It should be handled by UsersAvatarController
		user.update_attributes!(params[:user].except("avatar"))
		render json: user 
	end

	def create
		user = User.new(params[:user])
		user.password = "password" # we should generate random password and send it to user's email
		user.company = current_user.company
		user.save!
		render json: user
	end

end