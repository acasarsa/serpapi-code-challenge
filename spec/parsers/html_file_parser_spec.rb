# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'
require 'parsers/html_file_parser'

RSpec.describe GoogleCarouselExtractor::Parsers::HtmlFileParser do
  let(:file_path) { './spec/fixtures/van-gogh-paintings.html' }

  subject(:parser) { described_class.new(file_path) }

  describe '#parse_html' do
    it 'parses the HTML file and returns a Nokogiri::HTML::Document' do
      content = parser.parse_html
      expect(content).to be_a(Nokogiri::HTML::Document)
    end
  end
end
# it 'does not parse img tags that do not have image data yet' do
#   artwork_with_no_image = parsed_a_tags.css('img')
# end

# this should be done in the extractor area.
# it 'parses HTML and includes expected data' do
#   parsed_carousel_images = parsed_a_tags.css('img')

#   result_with_images['artworks'].each_with_index do |artwork, index|
#     parsed_image_src = parsed_carousel_images[index].attribute_nodes[2].value
#     expected_image_src = artwork['image'] ? artwork['image'][0, 30] : nil

#     if expected_image_src.nil?
#       expect(first_30_char_of_image_src).not_to include('Unexpected Data')
#     else
#       expect(first_30_char_of_image_src).to eq(expected_image_src)
#     end

#     expected_title = result_with_images['artworks'][index]['name']
#     expected_link = result_with_images['artworks'][index]['link']
#     expected_date = artwork['extensions']&.first

#     title_and_date = parsed_a_tags[index]['title']
#     href = parsed_a_tags[index]['href']
#     full_link = "https://www.google.com#{href}"

#     expect(title_and_date).to include(expected_title)
#     expect(full_link).to include(expected_link)

#     if expected_date.nil?
#       expect(title_and_date).not_to include('Unexpected Data')
#     else
#       expect(title_and_date).to include(expected_date)
#     end
#   end
# end
