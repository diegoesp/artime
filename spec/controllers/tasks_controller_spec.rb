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
      get :index, type: "RegularTask"
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 1
    end

  end

  describe "POST 'create'" do

    it "creates a regular task" do
      Task.all.length.should eq 1

      data = FactoryGirl.build(:task, company: Task.first.company).serializable_hash(except: [:created_at, :updated_at, :id] )

      post :create, task: data
      response.should be_success

      Task.all.length.should eq 2
    end

  it "creates a global task" do
      Task.all.length.should eq 1

      data = FactoryGirl.build(:task, company: Task.first.company).serializable_hash(except: [:created_at, :updated_at, :id] )
      data[:type] = "GlobalTask"

      post :create, task: data
      response.should be_success

      Task.all.length.should eq 2
      Task.last.type.should eq "GlobalTask"      
      GlobalTask.find(Task.last.id).should_not be_nil
      lambda {
        RegularTask.find(Task.last.id)
        }.should raise_error ActiveRecord::RecordNotFound
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