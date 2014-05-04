require 'spec_helper'

describe Plan do
  before(:each) do
  	@plan = create(:plan, name:"plan 1", description: "plan 1")
  end

  it "should require a name" do
  	@plan.name = nil
  	@plan.should_not be_valid
  end

  it "should require a description" do
  	@plan.description = nil
  	@plan.should_not be_valid
  end

end
