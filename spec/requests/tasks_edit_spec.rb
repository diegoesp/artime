require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "Tasks Edit" do

  before(:each) do
    user = create(:user, role_code: Role::MANAGER)
    create(:task, company: user.company)
    login_as user
    visit "/#tasks"
  end

  it "should allow me to update a task", js: true do
    task = Task.first
    page.first(:xpath, "//li[@data-task-id='#{task.id}']").click
    fill_in "name", with: "Caleidoscoping"
    find("#saveTask").click
    wait_until_ajax_finishes
    task.reload.name.should eq "Caleidoscoping"
  end

  it "should allow me to create a task", js: true do
    find("#newTask").click
    fill_in "name", with: "Animation"
    find("#saveTask").click
    wait_until_ajax_finishes
    Task.last.name.should eq "Animation"
  end

  it "should allow me to delete a task", js: true do
    task = Task.first
    page.first(:xpath, "//li[@data-task-id='#{task.id}']").click
    find("#deleteTask").click
    wait_until_ajax_finishes
    lambda {
      Task.find(task.id)
    }.should raise_error ActiveRecord::RecordNotFound
    
  end

end