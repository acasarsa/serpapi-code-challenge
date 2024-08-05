# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'
require 'parsers/html_file_parser'

RSpec.describe GoogleCarouselExtractor::Parsers::HtmlFileParser do
  let(:file_path) { './spec/fixtures/van-gogh-paintings.html' }

  subject(:parser) { described_class.new }

  describe '#parse_html' do
    it 'parses the HTML file and returns a Nokogiri::HTML::Document' do
      content = parser.parse_html(file_path)
      expect(content).to be_a(Nokogiri::HTML::Document)
    end
  end
end
