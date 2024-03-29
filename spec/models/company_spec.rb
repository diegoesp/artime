# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :integer
#

require 'spec_helper'

describe Company do
  
  before(:each) do
  	@company = build(:company)  	
  end

  it "should be valid" do
  	@company.should be_valid
  end

  it "should not allow duplicate names for companies" do
    @company.save!
    build(:company, name: @company.name).should_not be_valid
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
    @company.reload
    @company.has_user?(user).should be_true
  end

  it "should say when a user does not belong to a company" do
    user = create(:user)
    @company.has_user?(user).should_not be_true
  end

  it "should tell me which users have pending input" do
    user = create(:user, company: @company)
    @company.reload
    pending_input = @company.users_with_pending_input
    pending_input.length.should eq 1
    pending_input.first.should eq user
  end

  it "should tell me what % of input is done" do
    user = create(:user, company: @company)
    @company.reload
    @company.input_completed_percentage.should eq 0
  end

  it "should get the internal project" do
    @company.save!
    @company.internal_projects.length.should eq 1
  end
end
