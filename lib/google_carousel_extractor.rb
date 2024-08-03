# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'logger'
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'parsers/html_file_parser'
require 'services/browser_service'

# main project run file
module GoogleCarouselExtractor
  def self.logger
    @logger ||= Logger.new($stdout)
  end
end
