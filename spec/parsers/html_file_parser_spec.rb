# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'
require_relative '../../lib/parsers/html_file_parser'

RSpec.describe GoogleCarouselExtractor::Parsers::HtmlParser do
  let(:file_path) { './spec/fixtures/van-gogh-paintings.html' }

  subject(:parser) { described_class.new(file_path) }

  describe '#ready_html_content' do
    it 'parses the HTML file and returns a Nokogiri::HTML::Document' do
      content = parser.ready_html_content
      expect(content).to be_a(Nokogiri::HTML::Document)
    end
  end
end
