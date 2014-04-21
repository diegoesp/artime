require 'spec_helper'

describe Company do
  
  before(:each) do
  	@company = build(:company)  	
  end

  it "should be valid" do
  	@company.should be_valid
  end

  it "should require the active field" do
  	@company.active = nil
  	@company.should_not be_valid
  end

  it "should require the name field" do
  	@company.name = nil
  	@company.should_not be_valid
  end

  it "should not allow name to have more than 50 chars" do
  	@company.name = "c" * 51
  	@company.should_not be_valid
  end

  it "should say when a user belongs to a company" do
    user = create(:user, company: @company)
    @company.has_user?(user).should be_true
  end

    it "should say when a user does not belong to a company" do
    user = create(:user)
    @company.has_user?(user).should_not be_true
  end

end
