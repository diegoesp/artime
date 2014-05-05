# Manages plans
class PlansController < ApiApplicationController
	
	def index		
		render json: Plan.where(active: true)
	end

end