# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'logger'
require_relative 'parsers/html_file_parser'

# main project run file
module GoogleCarouselExtractor
  def self.logger
    @logger ||= Logger.new($stdout)
  end
end
