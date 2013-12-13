require 'bundler'
Bundler.require
require 'capybara/poltergeist'
require 'capybara/rspec'
#Capybara.default_wait_time = 0
Capybara.register_driver :poltergeist do |app|
  options = {
    debug: true,

    :phantomjs_options => [
      "--web-security=no",
      "--local-to-remote-url-access=yes",
      "--disk-cache=yes"
  ]
  }
  Capybara::Poltergeist::Driver.new(app, options)
end
RSpec.configure do |c|
  c.color_enabled = true
  c.tty = true
  def screenshot(name="screenshot")
    page.driver.render("source/ignore/#{name}.jpg",full: true)
  end
end

Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist
Capybara.app_host = "http://localhost:3506/"
