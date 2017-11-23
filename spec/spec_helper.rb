require 'rspec'
require 'capybara/rspec'

require_relative '../app.rb'

Capybara.app = Sinatra::Application
