require 'rspec'
require 'nokogiri'
require '../lib/main'

RSpec.configure do |config|
  # Use the specified formatter
  config.formatter = :documentation

  # Only run examples with the specified metadata
  config.filter_run_when_matching :focus

  # Enable flags for individual examples or groups
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # Disable RSpec exposing methods globally
  config.disable_monkey_patching!

  # Enable warnings
  config.warnings = true

  # Set default order of running specs
  config.order = :random

  # Only run examples with the specified metadata
  config.filter_run_when_matching :focus

  # Seed global randomization in this process
  Kernel.srand config.seed
end
