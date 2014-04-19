require 'spec_helper'

describe ProjectsController do

  render_views
  
  before(:each) do
  	user = create(:user, role_code: Role::MANAGER)
    client = create(:client, company: user.company)
  	project_1 = create(:project, client: client)
  	project_2 = create(:project, client: client)

  	sign_in user
  end

  describe "GET 'index'" do

    it "returns a list of projects for the dashboard" do
      get :index
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 2
    end

  end

end