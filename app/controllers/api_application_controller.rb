# To be used by any controller that exposes an API in the application
class ApiApplicationController < ApplicationController

	around_filter :api_error_filter

	# 
	# Do not include header while serializing to JSON
	#
	# @return [Hash] An option forcing active_model_serializer not to include headers
	def default_serializer_options
		{root: false}
	end

	private

	def api_error_filter
		begin
			yield
		rescue Exception => e
			logger.debug serialize_exception(e)
			render :json => { :errors => e.message }, :status => 422
		end
	end

	def serialize_exception(e)
		str = ""
		str += "Error raised by API:\n"
		str += "#{e.message}\n"
		str += JSON.pretty_generate(JSON.parse(e.backtrace.to_json))
		str
	end

	def is_manager_filter
		raise "user is not logged in" if current_user.nil?
		raise "Cannot access this method if user is not manager" unless current_user.manager?
	end

	def can_user_see_project
		project = Project.find(params[:project_id])
		raise "Project does not exist" if project.nil?
		raise "User has no access to this project" unless project.has_user?(current_user) or current_user.manager?
	end

	def can_user_see_user
		target_user_id = (params[:id] == "me") ? current_user.id : params[:id]
		target_user = User.find(target_user_id)
		raise "User has no access to this user" unless current_user.company.has_user?(target_user)
	end
end