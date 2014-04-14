require 'spec_helper'

describe HomeController do

  render_views
  
  describe "GET 'index'" do
    it "returns a valid page" do
      get :index
        response.should be_success
        response.body.should include("Sign up")
    end
  end

end