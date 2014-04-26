require 'spec_helper'

describe UsersController do

  render_views
  
  before(:each) do
	user = create(:user, role_code: Role::MANAGER)    
	sign_in user
  end

  describe "GET 'index'" do

	it "returns a list of users" do
	  create(:user, company: User.first.company)
	  create(:user, company: User.first.company)

	  get :index
	  response.should be_success
	  parsed_json = JSON.parse(response.body)
	  parsed_json.length.should eq 3
	end

  end

  describe "PUT 'update'" do

  	it "should update a user" do
  		user = create(:user, role_code: Role::DEVELOPER)    
		put :update, id: user.id, user: { role_code: Role::MANAGER }
		user.reload.role_code.should eq Role::MANAGER
  	end

  end

end