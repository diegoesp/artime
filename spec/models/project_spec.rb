require 'spec_helper'

describe Project do
  
  before(:each) do
  	@project = build(:project)
  end

  it "should be valid" do
  	@project.should be_valid
  end

  it "should require deadline" do
  	@project.deadline = nil
  	@project.should_not be_valid
  end

  it "should require active" do
  	@project.active = nil
  	@project.should_not be_valid
  end

  it "should not allow deadline to be before today" do
  	@project.deadline = (Date.today - 1)
  	@project.should_not be_valid
  end

	it "should require a name" do
  	@project.name = nil
  	@project.should_not be_valid
  end

  it "should require a description" do
  	@project.description = nil
  	@project.should_not be_valid
  end

  it "should return how many weeks are left" do
    @project.start_date = Date.today - 7
    @project.deadline = Date.today + 7
    @project.weeks_left.should eq 1
  end

  it "should return total weeks for project" do
    @project.start_date = Date.today
    @project.deadline = (Date.today + 7)
    @project.total_weeks.should eq 1
  end

  it "should return spent weeks as a percentage" do
    @project.start_date = Date.today - 14
    @project.deadline = Date.today + 14
    @project.weeks_spent_percentage.should eq 0.5
  end

  describe "hours management" do
    
    before(:each) do
      @project.tasks << create(:task, project: @project, hours_planned: 10)
      @project.tasks << create(:task, project: @project, hours_planned: 10)
      @project.tasks << create(:task, project: @project, hours_planned: 10)

      task = @project.tasks.first
      task.inputs << create(:input, task: task, hours: 4)
      task = @project.tasks.last
      task.inputs << create(:input, task: task, hours: 4)
    end

    it "should return total hours planned" do
      @project.hours_planned.should eq 30
    end

    it "should return total hours spent" do
      @project.hours_spent.should eq 8
    end

    it "should return hours spent as a percentage" do
      @project.hours_spent_percentage.should eq (8.to_f / 30).round(2)
    end

  end

end