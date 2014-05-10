require 'spec_helper'

describe UsersController do

  render_views
  
  before(:each) do
	@user = create(:user, role_code: Role::MANAGER)    
	sign_in @user
  end

  describe "GET 'index'" do

	it "returns a list of users" do
	  create(:user, company: @user.company)
	  create(:user, company: @user.company)

	  get :index
	  response.should be_success
	  parsed_json = JSON.parse(response.body)
	  parsed_json.length.should eq 3
	end

  end

  describe "PUT 'update'" do

		it "should update a user as a manager" do
			user = create(:user, role_code: Role::DEVELOPER, company: @user.company)    
			put :update, id: user.id, user: { role_code: Role::MANAGER }
			response.should be_success
			user.reload.role_code.should eq Role::MANAGER
		end

		it "should update a user as a user" do   
			put :update, id: @user.id, user: { first_name: "Walter White" }
			response.should be_success
			@user.reload.first_name.should eq "Walter White"
		end

		it "should prevent updating user out of company scope" do
			unscoped_user = create(:user)  
			put :update, id: unscoped_user.id, user: { first_name: "Walter White" }
			response.should_not be_success
		end

  end

	describe "DELETE 'destroy'" do

		it "should delete a user as a manager" do
			user = create(:user, role_code: Role::DEVELOPER, company: @user.company) 
			delete :destroy, id: user.id
			response.should be_success
			lambda {
				User.find(user.id)
			}.should raise_error(ActiveRecord::RecordNotFound)
		end

	end

end