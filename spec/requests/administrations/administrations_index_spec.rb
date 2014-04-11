require "spec_helper"
require "ejs"

describe "Administrations index" do

  before(:each)  do
    @administration1 = FactoryGirl.create(:administration1)
    @administration2 = FactoryGirl.create(:administration2)
  end
  
  it "should show two administrations in a table", :js => true do
    visit root_path
    page.find("#administrationsTable").all(:xpath, ".//tbody/tr").length.should eq 2    
  end

  it "should search for a single administration", :js => true do
    visit root_path
    fill_in("searchText", :with => "Blum")
    # Have to clean the table first or I may get the previous result
    page.execute_script("$(\"#table\").html(\"\")")
    page.find("#search").click
    page.find("#administrationsTable").all(:xpath, ".//tbody/tr").length.should eq 1
  end

  it "should allow to create a new administration", :js => true do
    visit root_path
    page.find("#new").click
    fill_in("name", :with => "New Test Administration")
    page.find("#save").click
    # I should have one additional administration now...
    page.find("#administrationsTable").all(:xpath, ".//tbody/tr").length.should eq 3
    # ... that has a name that includes "New Test"
    page.should have_content("New Test")
  end

  it "should allow me to update an administration", :js => true do
    visit root_path
    # Click the first show button in the table
    first(:xpath, "//input[@id='show']").click
    # Update my admin
    fill_in("name", :with => "Updated admin")
    page.find("#save").click
    # Go back
    page.find("#cancel").click
    # I should have an administration that is called "Updated admin"
    page.should have_content("updated successfully")
  end

  it "should allow me to delete the first administration", :js => true do
    visit root_path
    # Click the first destroy button
    first(:xpath, "//input[@id='destroy']").click
    # Wait for the modal window to be visible
    page.should have_selector("#deleteConfirm", visible: true)
    # Confirm deletion
    page.find("#deleteConfirm").click
    # Check that I have only one admin left
    page.find("#administrationsTable").all(:xpath, ".//tbody/tr").length.should eq 1
  end

end