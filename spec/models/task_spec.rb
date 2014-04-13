require 'spec_helper'

describe Task do
  before(:each) do
  	@task = build(:task)
  end

  it "should be valid" do
  	@task.should be_valid
  end

	it "should require a name" do
  	@task.name = nil
  	@task.should_not be_valid
  end

	it "should require a project" do
  	@task.project = nil
  	@task.should_not be_valid
  end

  it "should require deadline" do
  	@task.deadline = nil
  	@task.should_not be_valid
  end

  it "should require hours_planned" do
  	@task.hours_planned = nil
  	@task.should_not be_valid
  end

  it "should give me hours already spent" do
  	@task.save!
  	create(:input, task: @task, hours: 8)
  	create(:input, task: @task, hours: 3)
  	create(:input, task: @task, hours: 2)
  	@task.hours_spent.should eq 13
  end

  it "should find similar tasks to calculate stats" do
  	3.times do 
  		create(:task, name: "3D Modeling")
  	end

  	Task.find_similar("3D").length.should eq 3
  end
end