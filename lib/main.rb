# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'logger'

# main project run file
module CarouselExtractor
  def self.logger
    @logger ||= Logger.new($stdout)
  end
end
