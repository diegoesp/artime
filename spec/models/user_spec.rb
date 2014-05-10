# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE), not null
#

require 'spec_helper'

describe User do

	before (:each) do
		@user = build(:user)
	end

	it "should be a valid object" do
		@user.should be_valid
	end

	it "should require the username" do
		@user.username = ""
		@user.should_not be_valid
	end

	it "should require an email" do
		@user.email = ""
		@user.should_not be_valid
	end

	it "should require email to be unique in the context of a company" do
		@user.save!

		user_2 = build(:user, email: @user.email, company: @user.company)
		user_2.should_not be_valid
	end

	it "should not require email to be unique between companies" do
		@user.save!

		user_2 = build(:user, email: @user.email)
		user_2.should be_valid
	end

	it "should tell me if the user has pending input" do
		@user.save!
		@user.pending_input?.should be_true
	end

	it "should tell me how many pending inputs the user has" do
		@user.save!

		pending_input, total = @user.pending_input
		pending_input.should > 15

		# Input something on Monday. Now I should get one day less
		# I have to go 7 days back. If not, test case fails if today is Sunday
		date = Date.today - 7
		# Pick monday
		date = (date - date.wday) + 1
		# Input something
		create(:input, input_date: date, user: @user)
		# Check again. I should get one less day needed for input
		@user.pending_input[0].should == (pending_input - 1)
	end

	it "should detect if a user has missing input on last Friday" do
		@user.save!
		# Get last sunday
		date = Date.today - Date.today.wday
		# go back...
		date = date - 4.weeks
		# ... and input 4 hours for every day, EXCEPT last friday
		last_friday = Date.today - Date.today.wday - 2.day
		while date < Date.today
			create(:input, user: @user, input_date: date) unless (date.wday == 0 or date.wday == 6 or date == last_friday)
			date = date + 1.day
		end
		@user.pending_input?.should be_true
	end

	it "should allow me to upload an avatar" do
		file_name = "rails.png"
		@user.avatar = File.open("#{Rails.root}/app/assets/images/#{file_name}", "r")
		@user.save!
		@user.avatar_file_name.should eq file_name
		@user.avatar.url.should include(file_name) 
	end

	it "should return the missing avatar image if no avatar was uploaded" do
		@user.avatar.url.should include "missing_avatar.png"
	end

end