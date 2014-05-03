class UsersAvatarController < ApiApplicationController
  
  before_filter :authenticate_user!  
  before_filter :can_user_see_user, except: [:show]
  
  respond_to :json

  def show
    user_id = (params[:id] == "me") ? current_user.id : params[:id]
    user = User.find(user_id)
    render :json => user
  end

  def destroy
    user_id = (params[:id] == "me") ? current_user.id : params[:id]
    user = User.find(user_id)
    user.avatar = nil
    user.save!
    render :json => user 
  end

  def update
  	user_id = (params[:id] == "me") ? current_user.id : params[:id]
    user = User.find(user_id)
    user.avatar = params[:avatar]
    user.save!
		respond_to do |format|
      format.html { redirect_to (root_path) }
      format.json { render :json => user }
    end
  end

end