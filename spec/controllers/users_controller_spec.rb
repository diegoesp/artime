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
		user.reload.role_code.should eq Role::MANAGER
	end

	it "should update a user as a user" do   
		put :update, id: @user.id, user: { first_name: "Walter White" }
		@user.reload.first_name.should eq "Walter White"
	end

	it "should prevent updating user out of company scope" do
		unscoped_user = create(:user)  
		put :update, id: unscoped_user.id, user: { first_name: "Walter White" }
		response.body.should match "User has no access to this user"
	end

  end

end