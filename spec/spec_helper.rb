# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Capybara integration with require
require 'capybara/rspec'
require 'capybara/rails'
require 'support/warning_suppressor'
require 'capybara/poltergeist'
require 'support/poltergeist_crespon_driver'
# Force every thread to use the same connection in a synchronized way
require 'support/base'
# Disable private pub when using PostgreSQL + zeus in tests
require 'support/disable_private_pub'

# Test coverage
require 'simplecov'
require 'simplecov-rcov'

RSpec.configure do |config|

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Always display color in the console
  config.color_enabled = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Test coverage
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'

  config.before(:each, js: true) do
    # Comment this line if you want to use Selenium
    Capybara.current_driver = :poltergeist_crespon

    RSpec::Core::Runner.disable_autorun!
    
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each, js: false) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    I18n.locale = "es"
    
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each, js: true) do
  end

  # Stabilizing tests
  config.before(:all) do
    DeferredGarbageCollection.start
  end

  # Stabilizing tests
  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Present version of RSpec packs a bug with the includes order. Some of 
  # the calls (like visit) will be unavailable. This fixes it.
  config.include Capybara::DSL

  # Set up so you can log in and logout inside rspec fixtures
  #
  # sign_in :user, @user   # sign_in(scope, resource)
  # sign_in @user          # sign_in(resource)
  # sign_out :user         # sign_out(scope)
  # sign_out @user         # sign_out(resource)
  config.include Devise::TestHelpers, :type => :controller

  # Include Factory Girl helper methods (aka create instead FactoryGirl.create and such)
  config.include FactoryGirl::Syntax::Methods
end

# 
# Call it every time you need Ajax to finish all pending operations. Tipically
# used when you're waiting for a content to be refreshed.
# 
# Additional notes: This is just a simple sleep for now. The idea behind this
# is to draw something in the page to give information to capybara on how
# many connections are currently open by Ajax so we can trace and wait in a
# smarter way
def wait_until_ajax_finishes
  sleep(0.2)
end