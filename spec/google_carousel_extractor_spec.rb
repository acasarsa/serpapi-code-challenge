# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'logger'

require 'parsers/html_file_parser'
require 'services/browser_service'
require 'carousel_extractor'
require 'google_carousel_extractor'

RSpec.describe GoogleCarouselExtractor do
  let(:file_path) { './spec/fixtures/van-gogh-paintings.html' }
  let(:parser) { GoogleCarouselExtractor::Parsers::HtmlFileParser.new }

  describe '.run' do
    it 'extracts artworks and saves them to a file' do
      expect(File).to receive(:open).with('output_data.json', 'w').and_yield(StringIO.new)
      expect(GoogleCarouselExtractor.logger).to receive(:info).with(/Extracted artworks saved to/)
      GoogleCarouselExtractor.run(parser, file_path)
    end

    it 'logs a warning if no artworks are extracted' do
      allow_any_instance_of(GoogleCarouselExtractor::CarouselExtractor).to receive(:extract).and_return([])
      expect(GoogleCarouselExtractor.logger).to receive(:warn).with(/No artworks were extracted/)
      GoogleCarouselExtractor.run(parser, file_path)
    end
  end

  describe '.demo' do
    it 'executes the demo without errors' do
      expect { GoogleCarouselExtractor.demo }.not_to raise_error
    end
  end
end
