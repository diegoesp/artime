require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "Project Edit" do

  before(:each) do
    user = create(:user, role_code: Role::MANAGER)
    create(:client, company: User.first.company)
    login_as user    
  end

  it "should allow me to create a new project", js: true do
    visit "/#projects"
    page.first("#new").click
    fill_in "name", with: "Ficciones"
    # For some VERY weird reason select does not work with this combo.
    # I had to solve it this way
    page.execute_script("$('#client_id').val('#{Client.last.id}')");
    fill_in "start_date", with: Date.today
    fill_in "deadline", with: Date.today + 2.month
    fill_in "description", with: "A movie about Jorge Luis Borges book"

    find("#saveButton").trigger("click")
    page.should have_content "Project was saved successfully"
  end

  it "should allow me to update an existing project", js: true do
    project = create(:project, client: Client.last)
    visit "/#projects"
    sleep(2)
    page.first("[data-project-id='#{project.id}']").click
    # Update description
    fill_in "description", with: "new"
    sleep(2)
    find("#saveButton").click
    wait_until_ajax_finishes
    sleep(2)
    project.reload.description.should eq "new"
  end

end