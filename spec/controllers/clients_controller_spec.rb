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
			parsed_json.length.should eq Client.all.length
		end

	end

	describe "POST 'create'" do

		it "creates a client" do
			clients_count = Client.all.length

			data = FactoryGirl.build(:client, name: 'Terrabusi', company: Client.first.company).serializable_hash(except: [:created_at, :updated_at, :id, :company_id ] )
			data[:client] = data.clone

			post :create, data

			Client.all.length.should eq (clients_count + 1)
			Client.last.company.should_not be_nil
		end

	end

	describe "PUT 'update'" do

		it "updates a client" do
			client = Client.first
			put :update, id: client.id, client: { name: "Tecnopolis" }
			client.reload.name.should eq "Tecnopolis"
		end
		
	end

	describe "DELETE 'destroy'" do

		it "deletes a client" do
			clients_count = Client.all.length
			delete :destroy, id: Client.all.last.id
			Client.all.length.should eq (clients_count - 1)
		end

	end

end