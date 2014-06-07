require 'spec_helper'

describe Timesheet do

  before(:each) do
    # Input 8 hours for Monday...
    @input = create(:input, input_date: Date.today - Date.today.wday + 1)
    # ... and get the timesheet
    @timesheet = Timesheet.all(@input.user, Date.today - Date.today.wday)
  end

  it "should give me my table to input hours on it" do
    # the input should be here
    Input.first.hours.should eq 8
  end

  it "should get me available tasks to be added to timesheet" do
    project = @input.project_task.project
    Timesheet.tasks(project).length.should eq 1
  end

  it "should automatically add the global project to the timesheet" do
    company = @input.project_task.project.client.company

    user = create(:user, company: company)
    Timesheet.projects(user).length.should eq 1
  end

  it "should allow me to update the timesheet" do
    # update the time
    @timesheet.first.week_input["0"] = 4
    Timesheet.update(@input.user, @input.input_date, @timesheet)

    Input.first.hours.should eq 4
  end

  it "should tell me how many billable hours I have for a week" do
    # I need to add a second non-billable task for calculations
    task = create(:task, billable: false, company: @input.project_task.task.company)

    project = @input.project_task.project
    project.project_tasks << create(:project_task, task: task, project: project)
    project.save!

    user = @input.user
    create(:input, project_task: project.project_tasks.last, user: user)

    # Get the date_from
    date_from = @input.input_date  - @input.input_date.wday
    # Calculate
    Timesheet.billable_hours(date_from, user).should eq 0.2
  end

  it "should tell me which tasks are unassigned" do
    project = Project.last
    Timesheet.unassigned_tasks(project).length.should eq 0
    # Create a new task that is not included in the timesheet
    create(:task, company: project.client.company)
    Timesheet.unassigned_tasks(project).length.should eq 1
  end

  it "should allow me to add a new task to this project" do
    project = Project.last
    company = project.client.company
    user = create(:user, company: company)
    # Pick a task that is not assigned
    task = create(:task, company: company)
    # Ask the timesheet to add it
    timesheet = Timesheet.create(user, project, task)
    timesheet.task_name.should eq task.name
    task.reload
    task.project_tasks.find(timesheet.id).should_not be_nil
  end

  it "should sent mails to managers when user adds a task" do
    ActionMailer::Base.deliveries = []

    create(:user, role_code: Role::MANAGER, company: @input.user.company)

    Timesheet.mail_task_added(@input.project_task, @input.user)

    ActionMailer::Base.deliveries.length.should eq 1
  end

  it "should not sent mails to managers from different companies when user adds a task" do
    ActionMailer::Base.deliveries = []

    create(:user, role_code: Role::MANAGER, company: @input.user.company)
    create(:user, role_code: Role::MANAGER)

    Timesheet.mail_task_added(@input.project_task, @input.user)

    ActionMailer::Base.deliveries.length.should eq 1
  end

end