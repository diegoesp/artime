require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "Users Edit" do

  before(:each) do
    user = create(:user, role_code: Role::MANAGER)
    login_as user
    create(:user, company: user.company)
    visit "/#users"
  end

  it "should allow me to update an user", js: true do
    user = User.last
    page.first(:xpath, "//a[@data-model-id='#{user.id}'][@class='edit-link']").click
    fill_in "first_name", with: "Brunwald"
    find("#save").click
    wait_until_ajax_finishes
    user.reload.first_name.should eq "Brunwald"
  end

  it "should allow me to create an user", js: true do
    find("#newUser").click
    fill_in "first_name", with: "Brunwald"
    fill_in "last_name", with: "Archivald"
    fill_in "username", with: "barchivald"
    fill_in "email", with: "barchivald@buckingham.com"
    find("#save").click
    wait_until_ajax_finishes
    User.last.username.should eq "barchivald"
  end

  it "should allow me to delete a user", js: true do
    user = User.last
    page.first(:xpath, "//a[@data-model-id='#{user.id}'][@class='edit-link']").click
    find("#delete").click
    wait_until_ajax_finishes
    lambda {
      User.find(user.id)
    }.should raise_error ActiveRecord::RecordNotFound
    
  end

end