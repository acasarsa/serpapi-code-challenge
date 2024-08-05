# frozen_string_literal: true

require 'rspec'
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
$LOAD_PATH.unshift(File.expand_path('../lib/google_carousel_extractor', __dir__))

require 'google_carousel_extractor'

RSpec.configure do |config|
  ENV['ENVIRONMENT'] = 'test'
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

  config.include ImageHelpers
  config.include ArtworkComparisonHelpers

end
