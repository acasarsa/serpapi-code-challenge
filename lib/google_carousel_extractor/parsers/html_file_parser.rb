# frozen_string_literal: true

require 'nokogiri'
require_relative '../services/browser_service'

module GoogleCarouselExtractor
  module Parsers
    # parses an html file with nokogiri
    class HtmlFileParser
      def initialize(file_path, headless: true)
        @file_path = file_path
        @headless = headless
      end

      def ready_html_content
        GoogleCarouselExtractor::Services::BrowserService.with_browser_lifecycle(headless: @headless) do |service|
          file_url = "file://#{File.expand_path(@file_path)}"
          html_content = service.fetch_html_content(file_url)
          Nokogiri::HTML(html_content)
        end
      end
    end
  end
end
