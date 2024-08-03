# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'logger'
$LOAD_PATH.unshift(File.expand_path('../lib/google_carousel_extractor', __dir__))

require 'parsers/html_file_parser'
require 'services/browser_service'
require 'carousel_extractor'

# main project run file
module GoogleCarouselExtractor
  def self.logger
    @logger ||= Logger.new($stdout)
  end
end
