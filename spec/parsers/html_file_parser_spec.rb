# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'
require 'pry'
require 'json'
require 'parsers/html_file_parser'

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

    it 'parses HTML and includes expected data', :focus do
      parsed_content = parser.ready_html_content
      parsed_a_tags = parsed_content.at_css('g-scrolling-carousel').css('a')
      parsed_carousel_images = parsed_a_tags.css('img')

      result_with_images['artworks'].each_with_index do |artwork, index|
        binding.pry
        first_30_char_of_image_src = parsed_carousel_images[index].attribute_nodes[2].value[0, 30]
        first_30_char_of_expected = artwork['image'][0, 30]
        expect(first_30_char_of_image_src).to eq(first_30_char_of_expected)

        # Check for extensions (e.g., date)
        expected_title = result_with_images['artworks'][index]['name']
        expected_link = result_with_images['artworks'][index]['link']
        expected_date = artwork['extensions']&.first

        title_and_date = parsed_a_tags[index]['title']
        href = parsed_a_tags[index]['href']
        full_link = "https://www.google.com#{href}"

        expect(title_and_date).to include(expected_title)
        expect(full_link).to include(expected_link)

        if expected_date.nil?
          expect(title_and_date).not_to include('Unexpected Data')
        else
          expect(title_and_date).to include(expected_date)
        end
      end
    end
  end
end
