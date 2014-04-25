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

end