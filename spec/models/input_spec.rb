require 'spec_helper'

describe Input do
  before(:each) do
  	@input = build(:input)
  end

  it "should be valid" do
  	@input.should be_valid
  end

  it "should require a task" do
  	@input.task = nil
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
  
end
