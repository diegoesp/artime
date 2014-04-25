require 'spec_helper'

describe TasksController do

  render_views
  
  before(:each) do  	
    task = create(:task)

    user = create(:user, company: task.company, role_code: Role::MANAGER)
  	sign_in user
  end

  describe "GET 'index'" do

    it "returns a list of tasks" do
      get :index
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 1
    end

  end

  describe "GET 'last_projects_report'" do

    it "returns a report on project tasks" do
    	client = create(:client, company: Task.first.company)
    	project = create(:project, client: client)
    	project_task = create(:project_task, project: project, task: Task.first)

      get :last_projects_report, id: Task.first.id
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 1
    end

  end

  describe "POST 'create'" do

    it "creates a task" do
      Task.all.length.should eq 1

      data = FactoryGirl.build(:task, company: Task.first.company).serializable_hash(except: [:created_at, :updated_at, :id] )

      post :create, task: data
      response.should be_success

      Task.all.length.should eq 2
    end

  end

  describe "PUT 'update'" do

    it "updates a task" do

      task = Task.first
      put :update, id: task.id, task: { name: "New task name" }
      response.should be_success
      task.reload.name.should eq "New task name"
    end
    
  end

  describe "DELETE 'destroy'" do

    it "deletes a task" do
      Task.all.length.should eq 1

      delete :destroy, id: Task.all.first.id
      response.should be_success

      Task.all.length.should eq 0
    end

  end

end