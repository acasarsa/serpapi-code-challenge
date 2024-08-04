# frozen_string_literal: true

require 'spec_helper'
require 'watir'
require 'services/browser_service'

RSpec.describe GoogleCarouselExtractor::Services::BrowserService do
  let(:url) { 'http://example.com' }
  let(:url2) { 'http://example.org' }

  describe '#fetch_html_content' do
    context 'in headless mode' do
      it 'fetches HTML content from the provided URL' do
        service = described_class.new(headless: true)
        html_content = service.fetch_html_content(url)

        expect(html_content).to include('<html')
        expect(html_content).to include('Example Domain')
      end

      it 'closes the browser after fetching content' do
        service = described_class.new(headless: true)
        service.fetch_html_content(url)
        expect(service.instance_variable_get(:@browser)).to be_nil
      end

      it 'fetches HTML content from two different URLs sequentially' do
        service = described_class.new(headless: true)

        # Fetch content from the first URL
        html_content1 = service.fetch_html_content(url)
        expect(html_content1).to include('<html')
        expect(html_content1).to include('Example Domain')

        # Ensure the browser has been closed before opening a new one
        expect(service.instance_variable_get(:@browser)).to be_nil

        # Fetch content from the second URL
        html_content2 = service.fetch_html_content(url2)
        expect(html_content2).to include('<html')
        expect(html_content2).to include('Example')

        # Ensure the browser has been closed again
        expect(service.instance_variable_get(:@browser)).to be_nil
      end
    end
  end

  describe '.with_browser_lifecycle' do
    it 'manages the browser lifecycle within a block' do
      html_content = nil
      described_class.with_browser_lifecycle(headless: true) do |service|
        html_content = service.fetch_html_content(url)
      end

      expect(html_content).to include('<html')
      expect(html_content).to include('Example Domain')
    end
  end
end
