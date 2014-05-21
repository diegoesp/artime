require 'spec_helper'

describe ProjectTasksController do

  render_views
  
  before(:each) do
    company = create(:company)
    client = create(:client, company: company)
    task = create(:task, company: company)
    @project = create(:project, client: client)
    project_task_1 = create(:project_task, project: @project, task: task)
    project_task_2 = create(:project_task, project: @project, task: task)

    user = create(:user, role_code: Role::MANAGER)
  	sign_in user
  end

  describe "GET 'index'" do

    it "returns a list of project tasks" do
      get :index, project_id: @project.id
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 2
    end
    
  end

  describe "POST 'create'" do

    it "creates a project task" do
      @project.project_tasks.length.should eq 2
      task = @project.client.company.tasks.last

      data = FactoryGirl.build(:project_task, project: @project, task: task).serializable_hash(except: [:created_at, :updated_at, :id] )
      data[:project_task] = data.clone

      post :create, data
      response.should be_success

      @project.reload.project_tasks.length.should eq 3
    end

  end

  describe "PUT 'update'" do

    it "updates a project task" do

      project_task = ProjectTask.first
      put :update, project_id: project_task.project.id, id: project_task.id, project_task: { hours_planned: 321 }
      project_task.reload.hours_planned.should eq 321
    end
    
  end

  describe "DELETE 'destroy'" do

    it "deletes a project task" do
      ProjectTask.all.length.should eq 2

      delete :destroy, project_id: @project.id, id: @project.project_tasks.first.id

      ProjectTask.all.length.should eq 1
    end

  end

end