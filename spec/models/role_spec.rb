require 'spec_helper'

describe Role do

  before(:each) do
  	@role = build(:role)
  end

  it "should be a valid object" do
  	@role.should be_valid
  end

  it "should require a company" do
  	@role.company = nil
  	@role.should_not be_valid
  end

  it "should require an user" do
  	@role.user = nil
  	@role.should_not be_valid
  end

  it "should return all roles" do
  	Role.codes.length.should > 2
  end

end
