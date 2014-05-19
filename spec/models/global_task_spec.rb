# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  billable   :boolean          default(TRUE), not null
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)      default("RegularTask"), not null
#

require 'spec_helper'

describe RegularTask do

  before(:each) do
  	@global_task = build(:global_task)    
  end

  it "should state not billable as default" do
    @global_task.billable.should eq false
  end
end
