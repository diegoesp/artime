Capybara.register_driver :poltergeist_crespon do |app|
  Capybara::Poltergeist::Driver.new(app, { timeout: 5 })
end