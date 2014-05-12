# Manages clients
class ClientsController < ApiApplicationController
	
	before_filter :is_manager!, except: [:index] 
	before_filter :can_user_see_client!, only: [:update, :destroy]

	def index		
		render json: Client.mine(current_user)
	end

	def create
		client = Client.new(params[:client])
		client.company_id = current_user.company_id
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

	private

	def can_user_see_client!
		raise "User cannot access this client" unless Client.find(params[:id]).company.has_user?(current_user)
	end

end