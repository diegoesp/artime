require 'spec_helper'

describe RegularTasksController do

  render_views
  
  before(:each) do  	
    task = create(:task)

    user = create(:user, company: task.company, role_code: Role::MANAGER)
  	sign_in user
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

end