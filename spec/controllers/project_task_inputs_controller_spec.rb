require 'spec_helper'

describe ProjectTaskInputsController do

  render_views
  
  before(:each) do
    input = create(:input)
    user = input.user
    
  	sign_in user
  end

  describe "GET 'index'" do

    it "returns my input grid" do
      get :index, { date_from: Date.today - Date.today.wday }
      response.should be_success
      parsed_json = JSON.parse(response.body)
      parsed_json.length.should eq 1
    end

  end

  describe "PUT 'update'" do

    it "update the input grid" do
      input = Input.first
      put :update, { id: input.project_task.id, input_date: Date.today, hours: 8 }
      response.should be_success
      parsed_json = JSON.parse(response.body)
      # Should return more than three fields at least
      parsed_json.length.should > 3
    end

  end

end