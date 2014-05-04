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

  describe "PUT 'update'" do

    it "update the input grid" do
      
      timesheet = 
      [
        project_task_id: Input.first.project_task.id,
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

end