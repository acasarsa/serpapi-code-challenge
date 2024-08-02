# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'
require 'pry'
require 'json'
require 'parsers/html_file_parser'

RSpec.describe GoogleCarouselExtractor::Parsers::HtmlFileParser do
  let(:file_path) { './spec/fixtures/van-gogh-paintings.html' }
  let(:expected_result_json) do
    file_content = File.read('./spec/fixtures/expected-array.json')
    JSON.parse(file_content)
  end

  subject(:parser) { described_class.new(file_path) }

  describe '#ready_html_content' do
    it 'parses the HTML file and returns a Nokogiri::HTML::Document' do
      content = parser.ready_html_content
      expect(content).to be_a(Nokogiri::HTML::Document)
    end

    it 'should contain expected images', :focus do
      content = parser.ready_html_content
      parsed_carousel_images = content.at_css('g-scrolling-carousel').css('a').css('img')
      first_image_src_value = parsed_carousel_images[0].attribute_nodes[2].value
      # binding.pry
      expect(first_image_src_value).to eq(expected_result_json['artworks'][0]['image'])
    end
  end
end
