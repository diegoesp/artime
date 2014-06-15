# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE), not null
#

require 'spec_helper'

describe Client do
  before(:each) do
  	@client = create(:client)
  end

  it "should require a name" do
  	@client.name = nil
  	@client.should_not be_valid
  end

  it "should return all clients for a manager" do
  	user = create(:user, role_code: Role::MANAGER, company: @client.company)
  	Client.mine(user).length.should eq Client.all.length
  end

  it "should not return clients that are not mine" do
  	user = create(:user)
  	Client.mine(user).length.should eq 0
    d
  end
end
