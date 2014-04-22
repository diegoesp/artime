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

  it "should require a company" do
  	@task.company = nil
  	@task.should_not be_valid
  end

  it "should give me average spent hours" do
    client = create(:client, company: @task.company)
    project = create(:project, client: client)

    # Have to save so project task company and task company can be checked to be the same
    @task.save!

    3.times do
      project_task = create(:project_task, project: project, task: @task)
      project_task.inputs << create(:input, project_task: project_task, hours: 4)
    end

    @task.average_spent_hours.should eq 4
  end

  it "should give me average estimated hours" do
    client = create(:client, company: @task.company)
    project = create(:project, client: client)

    # Have to save so project task company and task company can be checked to be the same
    @task.save!

    3.times do
      project_task = create(:project_task, project: project, task: @task, hours_planned: 8)
    end

    @task.average_planned_hours.should eq 8
  end
end