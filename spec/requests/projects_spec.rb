require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "Projects" do

  before(:each) do
    project = create(:project)
    user = create(:user, company: project.client.company, role_code: Role::MANAGER)
    login_as user
    visit "/#projects"
  end

  it "should search by project", js: true do
    project = Project.last

    # Hidden field    
    find(:xpath, "//select[@id='clients_select']", visible: false).set project.id
    fill_in "project_name", with: project.name
    fill_in "date", with: project.start_date
    page.first("#project_name").native.send_keys(:return)
    find(:xpath, "//tbody[@id='projects_tbody']/tr").should_not be_nil
  end

  it "should show nothing if name project is not found", js: true do
    fill_in "project_name", with: "This does not exists !"
    page.first("#project_name").native.send_keys(:return)
    lambda {
      find(:xpath, "//tbody[@id='projects_tbody']/tr").should_not be_nil
    }.should raise_error Capybara::ElementNotFound
  end

end