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

  it "should require deadline" do
  	@project_task.deadline = nil
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

end
