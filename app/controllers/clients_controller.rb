# Manages clients
class ClientsController < ApiApplicationController
	
	def index		
		render json: Client.mine(current_user)
	end

end