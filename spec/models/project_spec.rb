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
end
