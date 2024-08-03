# frozen_string_literal: true

require 'watir'

module GoogleCarouselExtractor
  module Services
    # The BrowserService class is responsible for managing a Watir browser instance.
    # used for parsing html that needs javascript to run properly
    # Example usage:
    #   service = GoogleCarouselExtractor::Services::BrowserService.new(headless: true)
    #   html_content = service.fetch_html_content('http://example.com')
    #
    # The class also offers a convenient `with_browser_lifecycle` method to handle the browser lifecycle
    # within a block, ensuring the browser is closed after the block's execution.
    class BrowserService
      def initialize(headless: true)
        @headless = headless
        @browser = nil
      end

      def fetch_html_content(source)
        start_browser
        @browser.goto(source)
        @browser.html
      ensure
        close_browser
      end

      def start_browser
        puts "Starting browser for: #{@headless ? 'headless' : 'full'}"
        @browser = Watir::Browser.new(:chrome, headless: @headless)
      end

      def close_browser
        if @browser
          puts "Closing browser for: #{@headless ? 'headless' : 'full'}"
          @browser.close
          @browser = nil
        else
          puts 'Browser already closed or not started.'
        end
      end

      # Class method to manage browser lifecycle within a block
      def self.with_browser_lifecycle(headless: true)
        service = new(headless: headless)
        yield service
      ensure
        service&.close_browser
      end
    end
  end
end
