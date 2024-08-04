# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'parsers/html_file_parser'
require 'carousel_extractor'

require 'pry'

RSpec.describe GoogleCarouselExtractor::CarouselExtractor do
  let(:file_path) { './spec/fixtures/van-gogh-paintings.html' }
  let(:file_path2) { './spec/fixtures/salvador-dali-paintings' }
  let(:parser) { GoogleCarouselExtractor::Parsers::HtmlFileParser.new(file_path) }
  let(:extractor) { GoogleCarouselExtractor::CarouselExtractor.new(parser) }
  let(:expected_artworks) do
    file_content = File.read('./spec/fixtures/expected-array.json')
    JSON.parse(file_content)['artworks']
  end
  let(:expected_artworks_with_images) do
    file_content = File.read('./spec/fixtures/expected-array-with-images.json')
    JSON.parse(file_content)['artworks']
  end
  let!(:extracted_artworks) { extractor.extract }

  subject(:extractor) { described_class.new(parser) }

  describe '#extract' do
    it 'processes image data properly' do
      expected_artworks_with_images.each_with_index do |artwork, index|
        extracted_image = process_base64_image(extracted_artworks[index]['image'])
        expected_image = process_base64_image(artwork['image'])

        expect(extracted_image).to eq(expected_image)
      end
    end

    context 'processing placeholder images as nil' do
      it "processes soon-to-be-visible placeholder images with custom data attribute: 'data-src' as nil" do
        extracted_image1 = extracted_artworks[8]['image']

        expect(extracted_image1).to be_nil
        expect(extracted_image1).to eq(expected_artworks[8]['image'])
      end

      it 'processes blank gif placeholder images as nil' do
        extracted_image2 = extracted_artworks[10]['image']

        expect(extracted_image2).to be_nil
        expect(extracted_image2).to eq(expected_artworks[10]['image'])
      end
    end

    it 'properly extracts name and date when date is nil' do
      sunflower_name = expected_artworks[2]['name']
      ext_sunflower_name = extracted_artworks[2]['name']
      sunflower_date = expected_artworks[2]['extensions']
      ext_sunflower_date = extracted_artworks[2]['extensions']

      expect(ext_sunflower_name).to eq(sunflower_name)
      expect(ext_sunflower_date).to eq(sunflower_date)
    end

    it 'extracts data from html as expected' do
      expect(extracted_artworks.length).to eq expected_artworks.length

      expected_artworks.each_with_index do |artwork, index|
        expected_name = artwork['name']
        expected_link = artwork['link']
        expected_date = artwork['extensions']

        extracted_name = extracted_artworks[index]['name']
        extracted_link = extracted_artworks[index]['link']
        extracted_date = extracted_artworks[index]['extensions']

        expect(extracted_name).to eq(expected_name)
        expect(extracted_link).to eq(expected_link)
        expect(extracted_date).to eq(expected_date)
      end
    end
  end
end

# TODO: test with other url
# test it with a different url
# create the readme
