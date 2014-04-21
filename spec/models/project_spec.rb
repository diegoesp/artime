require 'spec_helper'

describe Project do
  
  before(:each) do
  	@project = build(:project)
  end

  it "should be valid" do
  	@project.should be_valid
  end

  it "should require a client" do
    @project.client = nil
    @project.should_not be_valid
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

  describe "search_by" do

    before(:each) do
      @project.save!

      @user = create(:user, company: @project.client.company)
    end

    it "should allow me to search using criteria" do
      params = Hash.new
      params[:client] = @project.client.id
      params[:active] = true
      params[:project_name] = @project.name

      Project.search_by(params, @user).length.should eq 1
    end

    it "should allow me to search for a specific client" do
      # Get another project from another client
      client = create(:client, company: @project.client.company)
      create(:project, client: client)

      params = Hash.new
      params[:client] = @project.client.id

      # Should still return only one (for the client requested)
      Project.search_by(params, @user).length.should eq 1
    end
  end

  describe "tasks management" do
    
    before(:each) do
      @project.project_tasks << create(:project_task, project: @project, hours_planned: 10)
      @project.project_tasks << create(:project_task, project: @project, hours_planned: 10)
      @project.project_tasks << create(:project_task, project: @project, hours_planned: 10)

      task = @project.project_tasks.first
      task.inputs << create(:input, project_task: task, hours: 4)
      task = @project.project_tasks.last
      task.inputs << create(:input, project_task: task, hours: 4)
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

    it "should tell me if the project is not completed" do
      @project.completed?.should_not be_true
    end

    it "should tell me if the project is completed" do
      @project.project_tasks.each { |project_task|  project_task.completed = true }        
      @project.completed?.should be_true
    end
  end

  it "should say when a user in the project has access" do
    user = create(:user, company: @project.client.company)
    @project.has_user?(user).should_not be_true
  end

  it "should say when a user in the project has no access" do
    user = create(:user, company: @project.client.company)
    @project.users << user
    @project.has_user?(user).should be_true
  end

end