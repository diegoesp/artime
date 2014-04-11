class AdministrationsController < ApiApplicationController

	respond_to :json

  def create
    render json: Administration.create!(params[:administration])
  end

	def update
		render json: Administration.find(params[:id]).update_attributes!(params[:administration])
	end

	def show
		render json: Administration.find(params[:id])
	end

	# 

	# JSON API that searches for administrations

	# @param  name [String] (Optional) Approximate name of an administration.
	# 
	# @return [String] A JSON string containing the looked up administrations
	def index
		name = params[:name]

		if (name.blank?) 
			render json: Administration.all
		else
			render json: Administration.search_by_name(name)
		end
	end

	def destroy
		render json: Administration.find(params[:id]).destroy
	end

end