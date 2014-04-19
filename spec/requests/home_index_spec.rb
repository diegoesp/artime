require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "home index" do

  before(:each)  do
    project_1 = create(:project)
    project_2 = create(:project, client: project_1.client)

    user = create(:user, role_code: Role::MANAGER)

    login_as user
  end
  
  describe "dashboard" do 

    it "should show a couple of projects", :js => true do
      visit "/"

      page.all("[name='project_status']").length.should eq 2
    end

  end

end