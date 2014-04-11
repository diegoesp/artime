# == Schema Information
#
# Table name: administrations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Administration do

  before (:each) do
    @administration = FactoryGirl.create(:administration1)
  end

  it "should be a valid object" do
    @administration.should be_valid
  end

  it "should require a name" do
    @administration.name = ""
    @administration.should_not be_valid
  end

  it "should return a valid administration for a valid search" do
    administrations = Administration.search_by_name(@administration.name)
    administrations.length.should eq 1
    administrations[0].name.should == @administration.name
  end

  it "should not return a valid administration for an invalid name" do
    Administration.search_by_name("xyz").should == []
  end
end
