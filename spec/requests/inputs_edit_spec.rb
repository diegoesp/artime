require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "Tasks Edit" do

  before(:each) do
    user = create(:user, role_code: Role::MANAGER)
    client = create(:client, company: user.company)
    project = create(:project, client: client)
    project_task = create(:project_task, project: project)
    create(:input, user: user, input_date: Date.today, hours: 1, project_task: project_task)

    login_as user
    visit "/#inputs"
  end

  it "should allow me to update my hours", js: true do
    task = Task.first
    page.first(:xpath, "//input[@name='timesheet_task'][@data-index='0'][@data-weekday='0']").set "12"
    find("#save_timesheet").trigger("click")
    wait_until_ajax_finishes
    Input.last.hours.should eq 12
  end

  it "should allow me to add a new task", js: true do
    project_task = create(:project_task, project: Project.last)
    wait_until_ajax_finishes
    page.all(:xpath, "//input[@name='timesheet_task']").length.should eq 7
    find("#add_task").trigger("click")
    wait_until_ajax_finishes
    page.execute_script("$('#tasks').val('#{project_task.id}')");
    find("#add").click
    wait_until_ajax_finishes
    page.all(:xpath, "//input[@name='timesheet_task']").length.should eq 14
  end

end