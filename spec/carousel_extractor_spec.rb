# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'parsers/html_file_parser'
require 'carousel_extractor'
require 'google_carousel_extractor'

RSpec.describe GoogleCarouselExtractor::CarouselExtractor do
  let(:parser) { double('Parser', parse_html: parsed_html) }

  describe '#extract' do
    let(:parsed_html) do
      Nokogiri::HTML::DocumentFragment.parse(<<~HTML)
        <g-scrolling-carousel>
          <a href="/link1" title="Artwork 1 (1888)">
            <img src="https://example.com/image1.jpg" alt="Artwork 1" />
            <div class="title">Artwork 1</div>
            <div class="ellip">1888</div>
          </a>
          <a href="/link2" title="Artwork 2">
            <img src="https://example.com/image2.jpg" alt="Artwork 2" />
            <div class="title">Artwork 2</div>
          </a>
          <a href="/link3" title="Artwork 3">
            <img src="placeholder_image.jpg" alt="Artwork 3" data-src="placeholder_image.jpg"/>
            <div class="title">Artwork 3</div>
            <div class="ellip">1931</div>
          </a>
          <a href="/link4" title="Artwork 4 (1905)">
            <img src="https://example.com/image4.jpg" alt="Artwork 4" />
            <div class="title">Artwork 4</div>
            <div>1905</div>
          </a>
          <a href="/link5" title="Artwork 5 (1999)">
            <img src="https://example.com/image5.jpg" alt="Artwork 5" />
            <div class="title">Artwork 5</div>
            <div class="not-ellip">1999</div>
          </a>
          <a data-ti="ArtistToArtworks">...</a>
        </g-scrolling-carousel>
      HTML
    end

    it 'extracts artwork information correctly' do
      extractor = described_class.new(parser, parse_html: parsed_html)

      expect(extractor.extract).to eq([
                                        { 'name' => 'Artwork 1', 'link' => 'https://www.google.com/link1',
                                          'image' => 'https://example.com/image1.jpg', 'extensions' => ['1888'] },
                                        { 'name' => 'Artwork 2', 'link' => 'https://www.google.com/link2',
                                          'image' => 'https://example.com/image2.jpg' },
                                        { 'name' => 'Artwork 3', 'link' => 'https://www.google.com/link3', 'image' => nil, 'extensions' => ['1931'] },
                                        { 'name' => 'Artwork 4', 'link' => 'https://www.google.com/link4',
                                          'image' => 'https://example.com/image4.jpg', 'extensions' => ['1905'] },
                                        { 'name' => 'Artwork 5', 'link' => 'https://www.google.com/link5', 'image' => 'https://example.com/image5.jpg', 'extensions' => ['1999'] }
                                      ])
    end

    context 'private method testing' do
      let(:extractor) { described_class.new(parser, 'dummy_source') }
      let(:a_tag) { parsed_html.at_css('a') }

      it 'builds the link correctly' do
        allow(extractor).to receive(:build_link).and_call_original
        expect(extractor.send(:build_link, a_tag)).to eq('https://www.google.com/link1')
      end

      it 'extracts the title correctly' do
        allow(extractor).to receive(:extract_title).and_call_original
        expect(extractor.send(:extract_title, a_tag)).to eq('Artwork 1')
      end

      it 'extracts the date correctly' do
        allow(extractor).to receive(:extract_date).and_call_original
        expect(extractor.send(:extract_date, a_tag)).to eq('1888')
      end

      it 'extracts the image src correctly' do
        allow(extractor).to receive(:extract_image_src).and_call_original
        expect(extractor.send(:extract_image_src, a_tag)).to eq('https://example.com/image1.jpg')
      end
      context 'when .ellip class is missing' do
        let(:logger) { instance_double(Logger) }
        let(:parser) { double('Parser', parse_html: parsed_html) }
        let(:extractor) { described_class.new(parser, 'dummy_source') }

        before do
          allow(GoogleCarouselExtractor).to receive(:logger).and_return(logger)
          allow(logger).to receive(:warn)
        end

        it 'logs a warning and uses fallback method' do
          expect(logger).to receive(:warn).twice.with("Using fallback method to extract date. Check if 'ellip' class has changed or is missing.")
          extracted_artworks = extractor.extract([3, 4])

          date_from_no_class = extracted_artworks[0]['extensions'].first
          date_from_different_class = extracted_artworks[1]['extensions'].first

          expect(date_from_no_class).to eq('1905')
          expect(date_from_different_class).to eq('1999')
        end
      end
    end
  end
  describe '#extract (with real HTML data)' do
    let(:van_gogh_html) { './spec/fixtures/van-gogh-paintings.html' }
    let(:dali_html) { './spec/fixtures/salvador-dali-paintings.html' }

    let(:expected_van_gogh_artworks) do
      JSON.parse(File.read('./spec/fixtures/expected-array.json'))['artworks']
    end

    let(:expected_dali_artworks) do
      JSON.parse(File.read('./spec/fixtures/expected-dali-array.json'))
    end

    it 'extracts Van Gogh artwork information correctly' do
      parser = GoogleCarouselExtractor::Parsers::HtmlFileParser.new
      extractor = described_class.new(parser, van_gogh_html)

      extracted_artworks = extractor.extract

      compare_artworks_handling_nil_image_cases(extracted_artworks, expected_van_gogh_artworks)
    end

    it 'extracts Dali artwork information correctly' do
      parser = GoogleCarouselExtractor::Parsers::HtmlFileParser.new
      extractor = described_class.new(parser, dali_html)

      extracted_artworks = extractor.extract

      compare_artworks_handling_nil_image_cases(extracted_artworks, expected_dali_artworks)
    end

    it 'properly extracts name when date is nil and does not add extensions key' do
      parser = GoogleCarouselExtractor::Parsers::HtmlFileParser.new
      extractor = described_class.new(parser, van_gogh_html)

      extracted_artwork = extractor.extract([2]).first
      expect(extracted_artwork).not_to have_key('extensions')
      expect(extracted_artwork['name']).to eq expected_van_gogh_artworks[2]['name']
    end

    context 'processing placeholder images as nil' do
      it "processes soon-to-be-visible placeholder images with custom data attribute: 'data-src' as nil" do
        parser = GoogleCarouselExtractor::Parsers::HtmlFileParser.new
        extractor = described_class.new(parser, van_gogh_html)

        nil_image = extractor.extract([8]).first['image']

        expect(nil_image).to be_nil
        expect(nil_image).to eq(expected_van_gogh_artworks[8]['image'])
      end

      it 'processes blank gif placeholder images as nil' do
        parser = GoogleCarouselExtractor::Parsers::HtmlFileParser.new
        extractor = described_class.new(parser, van_gogh_html)

        nil_image = extractor.extract([10]).first['image']

        expect(nil_image).to be_nil
        expect(nil_image).to eq(expected_van_gogh_artworks[10]['image'])
      end
    end
  end
end
