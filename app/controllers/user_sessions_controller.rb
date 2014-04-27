class UserSessionsController < ApiApplicationController
  
  respond_to :json

  # 
  # Returns the user that is logged in. No parameter is expected.
  # 
  def me
  	render json: current_user, serializer: UserSessionSerializer
  end

end