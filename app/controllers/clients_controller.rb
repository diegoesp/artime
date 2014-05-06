# Manages clients
class ClientsController < ApiApplicationController
	
	before_filter :is_manager!, except: [:index] 

	def index		
		render json: Client.mine(current_user)
	end

	def create
		client = Client.new(params[:client])
	    client.save!
	    render json: client
	end

	def update
	    client = Client.find(params[:id])
	    client.update_attributes!(params[:client])
	    render json: client
	end

	def destroy
	    client = Client.find(params[:id])
	    render json: client.destroy
	end

end