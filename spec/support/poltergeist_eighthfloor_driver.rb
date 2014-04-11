Capybara.register_driver :poltergeist_eighthfloor do |app|
  Capybara::Poltergeist::Driver.new(app, { timeout: 5 })
end