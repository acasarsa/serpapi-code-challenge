# frozen_string_literal: true

require 'nokogiri'
require_relative '../services/browser_service'

module GoogleCarouselExtractor
  module Parsers
    # Parses an html file with nokogiri
    class HtmlFileParser
      def initialize(headless: true)
        @headless = headless
      end

      def parse_html(file_path)
        GoogleCarouselExtractor::Services::BrowserService.with_browser_lifecycle(headless: @headless) do |service|
          file_url = "file://#{File.expand_path(file_path)}"
          html_content = service.fetch_html_content(file_url)
          Nokogiri::HTML(html_content)
        end
      rescue StandardError => e
        raise "An error occurred: #{e.message}"
      end
    end
  end
end
