# == Schema Information
#
# Table name: inputs
#
#  id              :integer          not null, primary key
#  project_task_id :integer
#  user_id         :integer
#  input_date      :date
#  hours           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Input do
  before(:each) do
  	@input = build(:input)
  end

  it "should be valid" do
  	@input.should be_valid
  end

  it "should require a project_task" do
  	@input.project_task = nil
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
  
  
  it "should allow me to search" do
    @input.save!
    params = { :input_date => @input.input_date }
    Input.search_by(params, @input.project_task_id, @input.user).length.should eq 1
  end

end
