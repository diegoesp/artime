require 'spec_helper'

describe HomeController do

  render_views
  
  describe "GET 'index'" do
    it "returns a valid page" do
      get :index
        response.should be_success
        response.should render_template("index")
        response.body.should include("Loading")
    end
  end

end