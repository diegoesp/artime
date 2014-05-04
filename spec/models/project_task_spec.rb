require 'spec_helper'

describe ProjectTask do

  before(:each) do
  	@project_task = build(:project_task)
  end

  it "should be valid" do
  	@project_task.should be_valid
  end

	it "should require completed" do
  	@project_task.completed = nil
  	@project_task.should_not be_valid
  end

	it "should require billable" do
  	@project_task.billable = nil
  	@project_task.should_not be_valid
  end

	it "should require a project" do
  	@project_task.project = nil
  	@project_task.should_not be_valid
  end

  it "should require hours_planned" do
  	@project_task.hours_planned = nil
  	@project_task.should_not be_valid
  end

  it "should give me hours already spent" do
  	@project_task.save!
  	create(:input, project_task: @project_task, hours: 8)
  	create(:input, project_task: @project_task, hours: 3)
  	create(:input, project_task: @project_task, hours: 2)
  	@project_task.hours_spent.should eq 13
  end

  it "should give the tasks where the user can enter input" do
    # Create a user...
    user = create(:user, company: @project_task.task.company)
    # ...add it to the project...
    @project_task.project.users << user
    @project_task.save!
    # ...input something to ensure the task appears...
    date_from = Date.today - Date.today.wday
    create(:input, user: user, project_task: @project_task, input_date: date_from)
    # ... and try !
    ProjectTask.for_user(user, date_from).length.should eq 1
  end
end
