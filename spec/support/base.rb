# Forces to run the tests in a single connection no matter what.
# This allows us to employ transactional strategies to the capybara tests, but
# works only with some memory databases (like SQLite). It is unsafe for traditional databases.
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end

# (From Capybara documentation: https://github.com/jnicklas/capybara)
# 
# Some Capybara drivers need to run against an actual HTTP server. Capybara takes
# care of this and starts one for you in the same process as your test, but on another
# thread. Selenium is one of those drivers, whereas RackTest is not.
# If you are using a SQL database, it is common to run every test in a transaction, which 
# is rolled back at the end of the test (rspec-rails does this by default out of the box, for 
# example). Since transactions are usually not shared across threads, this will cause data 
# you have put into the database in your test code to be invisible to Capybara.
# To force every thread to use the same database connection, uncomment the statement below and include
# support/base.
# This works with in-memory databases like sqlite, but not with PostgreSQL (causes a segmentation fault)
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection