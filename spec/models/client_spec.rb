require 'spec_helper'

describe Client do
  before(:each) do
  	@client = create(:client)
  end

  it "should require a name" do
  	@client.name = nil
  	@client.should_not be_valid
  end
end
