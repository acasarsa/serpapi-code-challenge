# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'
require 'pry'
require 'json'
require_relative '../../lib/parsers/html_file_parser'

RSpec.describe GoogleCarouselExtractor::Parsers::HtmlFileParser do
  let(:file_path) { './spec/fixtures/van-gogh-paintings.html' }
  let(:result_with_images) do
    file_content = File.read('./spec/fixtures/expected-array-with-images.json')
    JSON.parse(file_content)
  end

  subject(:parser) { described_class.new(file_path) }

  describe '#ready_html_content' do
    it 'parses the HTML file and returns a Nokogiri::HTML::Document' do
      content = parser.ready_html_content
      expect(content).to be_a(Nokogiri::HTML::Document)
    end

    it 'correctly parses and matches image sources' do
      content = parser.ready_html_content
      parsed_carousel_images = content.at_css('g-scrolling-carousel').css('a').css('img')

      5.times do
        index_rand = rand(0...result_with_images['artworks'].length)

        first_30_char_of_image_src = parsed_carousel_images[index_rand].attribute_nodes[2].value[0, 30]
        first_30_char_of_expected = result_with_images['artworks'][index_rand]['image'][0, 30]

        expect(first_30_char_of_image_src).to eq(first_30_char_of_expected)
      end
    end

    it 'parsed HTML includes the expected data', :focus do
      content = parser.ready_html_content
      5.times do
        index_rand = rand(0...result_with_images['artworks'].length)
        expected_name = result_with_images['artworks'][index_rand]['name']
        expected_date = result_with_images['artworks'][index_rand]['extensions'][0]
        expected_link = result_with_images['artworks'][index_rand]['link']

        carousel_a_tags = content.at_css('g-scrolling-carousel').css('a')

        # Check if the title includes the expected name and date
        expect(carousel_a_tags[index_rand]['title']).to include(expected_name)
        expect(carousel_a_tags[index_rand]['title']).to include(expected_date)

        # Check if the href includes the expected link
        href = carousel_a_tags[index_rand]['href']
        full_link = "https://www.google.com#{href}"
        expect(full_link).to include(expected_link)
      end
    end
  end
end
