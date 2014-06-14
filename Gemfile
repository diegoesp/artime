source 'https://rubygems.org'

# Basic infrastructure gems ok
gem 'rails', '3.2.16'                                       # Good ol' Rails
gem 'activeadmin', '0.6.3'                                  # Provides an automatically generated backoffice
gem "meta_search", '>=0.9.2'                                # Dependency for active admin
gem 'i18n', "0.6.9"                                         # Ruby internationalization support
gem 'active_model_serializers', '0.8.1'                     # Serialization framework for our controllers
gem 'pg', "0.17.1 "                                         # PostgreSQL gem
gem 'backbone-on-rails', "1.0.0.0"                          # Generates code to automatically integrate backbone.js. Includes underscore
gem "execjs", "2.0.2"                                       # Allows to execute javascript. Used for the asset pipeline. Requires node.js
gem 'sass-rails', '3.2.6'                                   # SASS support
gem 'uglifier', '1.3.0'                                     # Javascript compressor used by Rails
gem 'validates_email_format_of', "1.5.3"                    # Validation gem for emails
gem "coffee-rails", "3.2.2"                                 # Required by tests => if not a warning is thrown
gem 'devise'

# Optional gems for additional features
gem "paperclip", "3.5.0"                                    # Easy file attachment library for Active Record
gem 'delayed_job_active_record', "4.0.0"                    # Schedules job to an internal queue
# gem 'private_pub', "1.0.3"                                  # Push technology (using Faye) for the chat feature
# gem 'thin', "1.5.1"                                         # Simple server used by private_pub
# gem 'clockwork', '0.7.3'                                    # cron-like gem to schedule repetitive tasks

# Javascript components
gem 'jquery-rails', "2.3.0"                                 # Provides JQuery
gem 'i18n-js', "3.0.0.rc5"                                  # Provides internationalization for javascript
gem 'bootstrap-sass', '~> 3.1.0'                            # Twitter Bootstrap using SASS instead of LESS
gem 'bootstrap-datepicker-rails'                            # powerful datepicker feature for jquery
gem 'momentjs-rails', '2.5.1'                               # Moment.js library for managing dates (better than Date)
gem "font-awesome-rails", "4.0.3.1"                         # Complementary icons for bootstrap
gem "jquery-fileupload-rails", "0.4.1"                    # JQuery File Upload plugin for Rails
# Additional Javascript features
# 
# gem 'bootstrap3-datetimepicker-rails', '2.1.30'           # Timepicker. Overlaps on datepicker functionality with bootstrap-datepicker. See http://eonasdan.github.io/bootstrap-datetimepicker/

# Gems exclusively used for development and test. Not needed @ prod environment
group :development, :test do
  gem "rspec-rails", "2.13.0"                               # RSpec testing framework interaction with rails
  gem 'launchy', "2.2.0"                                    # Launches the web browser via automation
  gem 'database_cleaner', '0.9.1'                           # Resets database between tests
  gem 'factory_girl_rails', "4.2.1"                         # Test fixtures
  gem 'annotate', "2.5.0"                                   # Annotates models adding the schema to the top of the file 
  gem 'capybara', "2.1.0"                                   # Support for testing web apps using a specific DSL
  gem 'selenium-webdriver', "2.40.0"                        # Driver for Capybara that allows to test using a full browser
  gem "poltergeist", "1.5.0"                                # Integrates phantomjs to Capybara
  gem 'rails-erd', "1.1.0"                                  # Generates a domain model graphic for easy documentation
  gem 'faker', "1.3.0"                                      # Generates fake data for your factories
  gem 'awesome_print'                                       # Prints objects in a pretty way in the console using the ap command
  gem "connection_pool", "1.2.0"                            # Custom connection pool. We use it to manage test connection pools
end

# Gems for CI
group :test do
  gem "ci_reporter", "1.9.2"
end

group :production do
  gem 'unicorn', '4.7.0'                                    # Powerful ruby - rails server
  gem 'daemons', '1.1.9'                                    # To run delayed job as a daemon
end