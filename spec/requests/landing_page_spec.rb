require "spec_helper"
require "ejs"
include Warden::Test::Helpers

describe "landing page" do

  describe "login" do 

    before(:each) do
      company = create(:company)
      create(:user, company: company, username: "ckent", password: "superman")
      visit "/users/sign_in"
    end

    it "should allow me to login", js: true do      
      fill_in "user_username", with: "ckent"
      fill_in "user_password", with: "superman"
      page.first("[name='commit']").click
      page.should have_content "Signed in successfully"
    end

    it "should allow me to reset my password", js: true do
      page.first("#forgot_your_password").click
      fill_in "user_username", with: "ckent"
      page.first("[name='commit']").click
      page.should have_content "You will receive an email with instructions"
    end

  end

  it "should allow me to register", js: true do
    visit "/users/sign_up"
    fill_in "user_first_name", with: "Clark"
    fill_in "user_last_name", with: "Kent"
    fill_in "user_username", with: "ckent"
    fill_in "user_email", with: "ckent@daily-planet.com"
    fill_in "user_password", with: "superman"
    fill_in "user_password_confirmation", with: "superman"
    fill_in "user_company_attributes_name", with: "Daily Planet"
    page.first("[name='commit']").click
    User.last.username.should eq "ckent"
  end

end