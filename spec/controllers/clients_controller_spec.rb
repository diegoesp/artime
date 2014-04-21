require 'spec_helper'

describe ClientsController do

  render_views
  
  before(:each) do
  	user = create(:user, role_code: Role::MANAGER)
    create(:client, company: user.company)
    create(:client, company: user.company)
    
  	sign_in user
  end

  describe "GET 'index'" do

    it "returns a list of clients" do
      get :index
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 2
    end

  end

end