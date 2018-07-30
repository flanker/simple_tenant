require 'bundler/setup'
require 'simple_tenant'
require 'mongoid'
require 'byebug'

Mongoid.load!('spec/mongoid.yml', :test)

# Mongoid.logger.level = Logger::DEBUG
# Mongo::Logger.logger.level = Logger::DEBUG
#
# Mongoid.logger = Logger.new(STDOUT)
# Mongo::Logger.logger = Logger.new(STDOUT)
#
# Mongo::Monitoring::CommandLogSubscriber::LOG_STRING_LIMIT = 3000

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
