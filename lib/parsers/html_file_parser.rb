# frozen_string_literal: true

require 'nokogiri'

module GoogleCarouselExtractor
  module Parsers
    # parses an html file with nokogiri
    class HtmlFileParser
      def initialize(file_path)
        @file_path = file_path
      end

      def ready_html_content
        html_content = File.read(@file_path)
        Nokogiri::HTML(html_content)
      end
    end
  end
end
