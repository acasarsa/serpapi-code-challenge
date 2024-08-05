# frozen_string_literal: true

require 'logger'
require 'json'
$LOAD_PATH.unshift(File.expand_path('../lib/google_carousel_extractor', __dir__))

require 'parsers/html_file_parser'
require 'services/browser_service'
require 'carousel_extractor'
require_relative '../spec/support/extraction_comparison_helpers'

# Sets up a demo and logger for app
module GoogleCarouselExtractor
  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      # Simple console formatter
      log.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity}: #{msg}\n"
      end
    end
  end

  def self.run(parser, file_path)
    extractor = GoogleCarouselExtractor::CarouselExtractor.new(parser, file_path)
    artworks = extractor.extract

    if artworks.empty?
      logger.warn('No artworks were extracted. Please check the HTML file and parser.')
    else
      output_file = 'output_data.json'
      File.open(output_file, 'w') do |file|
        file.write(JSON.pretty_generate(artworks))
      end
      logger.info("Extracted artworks saved to #{output_file}")
    end
  end

  def self.demo
    # ImageHelpers for demo use to process base64 image strings.
    # Use: process_base64_image(base64_string)
    #
    # Example: exp_image = process_base64_image(van_gogh_expected_array[0]['image'])
    #
    extend ImageHelpers
    # demo extraction from HTML file with van gogh paintings
    file_path = File.expand_path('../spec/fixtures/van-gogh-paintings.html', __dir__)
    van_gogh_expected_array = JSON.parse(File.read('spec/fixtures/expected-array.json'))['artworks']
    parser = GoogleCarouselExtractor::Parsers::HtmlFileParser.new
    extractor = GoogleCarouselExtractor::CarouselExtractor.new(parser, file_path)
    Pry.start(binding)
    van_gogh_paintings = extractor.extract
    pp van_gogh_paintings[0] # size 51

    # demo extraction from HTML file with salvador dali paintings
    file_path2 = File.expand_path('../spec/fixtures/salvador-dali-paintings.html', __dir__)
    dali_expected_array = JSON.parse(File.read('spec/fixtures/expected-dali-array.json'))
    parser2 = GoogleCarouselExtractor::Parsers::HtmlFileParser.new
    extractor2 = GoogleCarouselExtractor::CarouselExtractor.new(parser2, file_path2)
    Pry.start(binding)
    salvador_dali_paintings = extractor2.extract
    pp salvador_dali_paintings[0] # size 11
  end
end
