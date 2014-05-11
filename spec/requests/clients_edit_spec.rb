require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "Clients Edit" do

  before(:each) do
    user = create(:user, role_code: Role::MANAGER)
    create(:client, company: user.company)
    login_as user
    visit "/#clients"
  end

  it "should allow me to update a client", js: true do
    client = Client.first 
    page.first(:xpath, "//a[@data-client-id='#{client.id}'][@class='edit-link']").click
    fill_in "name", with: "Steve Wozniak"
    find("#save").click
    wait_until_ajax_finishes
    client.reload.name.should eq "Steve Wozniak"
  end

  it "should allow me to create a client", js: true do
    find("#new").click
    fill_in "name", with: "Steven Spielberg"
    find("#save").click
    wait_until_ajax_finishes
    Client.last.name.should eq "Steven Spielberg"
  end

  it "should allow me to delete a client", js: true do
    client = Client.first
    page.first(:xpath, "//a[@data-client-id='#{client.id}'][@class='delete-link']").click
    wait_until_ajax_finishes
    page.first(:xpath, "//button[@data-bb-handler='confirm']").click
    wait_until_ajax_finishes
    lambda {
      Client.find(client.id)
    }.should raise_error ActiveRecord::RecordNotFound
    
  end

end