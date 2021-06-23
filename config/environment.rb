# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# If in Spring & test env, load spec_helper.rb
if ENV['SPRING_ENV'] == 'test' && ENV['RAILS_ENV'] == 'test'
  require File.expand_path('../../spec/spec_helper', __FILE__)
end
