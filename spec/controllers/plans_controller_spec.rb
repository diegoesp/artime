require 'spec_helper'

describe PlansController do

	render_views
	
	before(:each) do
		create(:plan, name: "plan 1", description: "plan 1")
		create(:plan, name: "plan 2", description: "plan 2")
	end

	describe "GET 'index'" do

		it "returns a list of plans" do
			get :index
			response.should be_success
			parsed_json = JSON.parse(response.body)
			parsed_json.length.should eq 2
		end

	end

end