require 'spec_helper'

describe TimesheetsController do

  render_views
  
  before(:each) do
    input = create(:input, input_date: Date.today)
    user = input.user
    
  	sign_in user
  end

  describe "GET 'index'" do

    it "returns my timesheet" do
      get :index, { date_from: Date.today - Date.today.wday }
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 1
    end

  end

  describe "GET 'show'" do

    it "returns a single line of timesheet" do
      get :show, { id: ProjectTask.first.id }
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should > 1
    end

  end

  describe "PUT 'update'" do

    it "update the input grid" do
      
      timesheet = 
      [
        id: Input.first.project_task.id,
        week_input: 
        {
          0 => 0,
          1 => 0,
          2 => 8,
          3 => 4,
          4 => 0,
          5 => 0,
          6 => 0
        }
      ]

      date_from = Date.today - Date.today.wday

      put :update, { id: "mine", date_from: date_from, timesheet: timesheet }
      response.should be_success
      Input.first.hours.should eq 8
    end

  end

  describe "GET 'billable_hours'" do

    it "returns how many billable hours I have in my week" do
      get :billable_hours, { date_from: Date.today - Date.today.wday }
      response.should be_success
      response.body.to_f.should > 0
    end

  end

  describe "GET 'projects'" do

    it "returns my projects for inputing" do
      get :projects
      response.should be_success
      JSON.parse(response.body).length.should > 0
    end

  end

  describe "GET 'tasks'" do

    it "returns my tasks for inputing" do
      get :tasks, { project_id: Project.last.id }
      response.should be_success
      JSON.parse(response.body).length.should > 0
    end

  end

end