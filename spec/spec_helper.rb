
require "bundler/setup"

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/lib/flow_node_patron/utils/"
end

require "flow_node_patron"
require "byebug"


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
