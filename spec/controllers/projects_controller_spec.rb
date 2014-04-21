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

  describe "POST 'create'" do

    it "creates a project" do
      Project.all.length.should eq 2

      data = FactoryGirl.build(:project, client: Client.first).serializable_hash(except: [:created_at, :updated_at, :id] )
      data[:project] = data.clone

      post :create, data

      Project.all.length.should eq 3
    end

  end

  describe "PUT 'update'" do

    it "updates a project" do

      project = Project.first
      put :update, id: project.id, project: { name: "New name" }
      project.reload.name.should eq "New name"
    end
    
  end

  describe "DELETE 'destroy'" do

    it "deletes a project" do
      Project.all.length.should eq 2

      delete :destroy, id: Project.all.first.id

      Project.all.length.should eq 1
    end

  end

end