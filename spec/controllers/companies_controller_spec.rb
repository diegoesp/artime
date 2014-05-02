require 'spec_helper'

describe CompaniesController do

	render_views
	
	before(:each) do
		company = create(:company)
		user = create(:user, company: company, role_code: Role::MANAGER)
		sign_in user
	end

	describe "GET 'show'" do

		it "returns my company" do
			get :show, id: "mine"
			response.should be_success
			parsed_json = JSON.parse(response.body)
			parsed_json.length.should > 1
			parsed_json["users_with_pending_input"].should_not be_nil
		end
		
	end

end