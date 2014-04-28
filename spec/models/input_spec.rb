require 'spec_helper'

describe Input do
  before(:each) do
  	@input = build(:input)
  end

  it "should be valid" do
  	@input.should be_valid
  end

  it "should require a project_task" do
  	@input.project_task = nil
  	@input.should_not be_valid
  end

  it "should require a user" do
  	@input.user = nil
  	@input.should_not be_valid
  end

  it "should only allow hours from 1 to 24" do
  	@input.hours = 25
  	@input.should_not be_valid
  end

  it "should require an input date" do
  	@input.input_date = nil
  	@input.should_not be_valid
  end
  
  it "should give me my table to input hours on it" do
    # Input 8 hours for Monday
    @input.input_date = Date.today - Date.today.wday + 1
    @input.save!
    
    # Get the chart...
    inputs = Input.for_user(@input.user, Date.today - Date.today.wday)

    # ... and the input should be here !
    inputs.first.mon.should == 8
  end

  it "should allow me to search" do
    @input.save!
    params = { :input_date => @input.input_date }
    Input.search_by(params, @input.project_task_id, @input.user).length.should eq 1
  end

  it "should tell me how many billable hours I have for a week" do
    @input.save! 

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
    Input.billable_hours(date_from, user).should eq 0.2
  end
end