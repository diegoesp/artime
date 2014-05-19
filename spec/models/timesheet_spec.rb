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

  it "should get me available tasks for the timesheet" do
    user = @input.user
    Timesheet.tasks(user).length.should eq 1
  end

  it "should automatically add any global tasks to the timesheet" do
    user = @input.user
    Timesheet.tasks(user).length.should eq 1
    create(:task, type: "GlobalTask", company: user.company)
    Timesheet.tasks(user).length.should eq 2
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

end