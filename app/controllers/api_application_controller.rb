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

end