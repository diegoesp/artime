require 'spec_helper'

describe AdministrationsController do

  render_views

	before(:each) do
		@administration1 = FactoryGirl.create(:administration1)
		FactoryGirl.create(:administration2)
	end

	describe "GET index" do
		it "should return all administrations" do
			get :index
      parsed_json = JSON.parse(response.body)
			parsed_json.length.should eq 2
			parsed_json[0]["name"].should include("Blum")
		end
	end

  describe "GET index" do
    it "should return one administration" do
      get :index, name: @administration1.name
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 1
      parsed_json[0]["name"].should include("Blum")
    end
  end

	describe "GET show" do
		it "should return a valid administration" do
			get :show, id: @administration1.id
			parsed_json = JSON.parse(response.body)
			parsed_json["name"].should == @administration1.name
		end
	end

	describe "POST create" do
		it "should create a new administration" do
			name = "Administracion Tercera"
			post :create, administration: { name: name }
			parsed_json = JSON.parse(response.body)
			get :show, id: parsed_json["id"]
			parsed_json = JSON.parse(response.body)
			parsed_json["name"].should eq name
		end

    it "should not allow to create an administration without a name" do
      post :create, administration: { name: "" }
      response.code.should eq "422"
      parsed_json = JSON.parse(response.body)
      response.body.should match "Name can't be blank"
    end    
	end

	describe "POST update" do
		it "should update an existing administration" do
			name = "Blum administracion 2a edicion"
			put :update, id: @administration1.id, administration: { name: name }
			get :show, id: @administration1.id
			parsed_json = JSON.parse(response.body)
			parsed_json["name"].should eq name
		end

    it "should not allow to update using a blank name" do
      put :update, id:@administration1.id, administration: { name: "" }

      response.body.should match "Name can't be blank"
    end
  end
	
  describe "DELETE destroy" do
		it "should delete an existing administration" do
			delete :destroy, id: @administration1.id
 			get :show, id: @administration1.id
			response.body.should match "Couldn't find Administration"
		end	
	end

end