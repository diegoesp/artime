# Manages companies
class CompaniesController < ApiApplicationController
	
	before_filter :is_manager!

	def index		
		raise "Cannot return all companies"
	end

	def create
		raise "Cannot create new companies through this controller"
	end

	def show
		render json: current_user.company
	end

	def update
		raise "Cannot update a company through this controller"
	end

	def destroy
		raise "Cannot destroy a company through this controller"
	end

end