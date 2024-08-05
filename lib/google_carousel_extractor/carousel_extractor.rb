# frozen_string_literal: true

module GoogleCarouselExtractor
  # Processes the parsed data and extracts it into desired structure
  class CarouselExtractor
    def initialize(parser, html_source)
      @doc = parser.parse_html(html_source)
    end

    def extract(indices = nil)
      artworks = []
      a_tags = @doc.at_css('g-scrolling-carousel').css('a')

      a_tags = a_tags.select.with_index { |_, i| indices.include?(i) } if indices # If indices are provided, filter the a_tags

      a_tags.each do |a_tag|
        data_ti_attribute = a_tag.attribute_nodes.find { |attr| attr.name == 'data-ti' }&.value

        break if data_ti_attribute == 'ArtistToArtworks'

        title = extract_title(a_tag)
        link = build_link(a_tag)
        image = extract_image_src(a_tag)
        date = extract_date(a_tag)
        artworks << construct_artwork_object(name: title, date: date, link: link, image: image)
      end
      artworks
    end

    private

    def construct_artwork_object(attributes)
      artwork = {
        'name' => attributes[:name],
        'link' => attributes[:link],
        'image' => attributes[:image]
      }

      artwork['extensions'] = [attributes[:date]] if attributes[:date]

      artwork
    end

    def build_link(a_tag)
      a_tag_nodes = a_tag.attribute_nodes
      href = a_tag_nodes.find { |attr| attr.name == 'href' }.value
      "https://www.google.com#{href}"
    end

    def extract_title(a_tag)
      str = a_tag.attribute_nodes.find { |attr| attr.name == 'title' }&.value
      remove_date_from_title(str)
    end

    def remove_date_from_title(string)
      string&.gsub(/\s*\(\d{4}\)$/, '')
    end

    # TODO: use logger
    def extract_date(a_tag)
      date_element = a_tag.at_css('.ellip')
      if date_element
        date_text = date_element.text&.strip
        return date_text if valid_year?(date_text)
      end

      GoogleCarouselExtractor.logger.warn("Using fallback method to extract date. Check if 'ellip' class has changed or is missing.")
      fallback_date_text = a_tag.text&.strip&.gsub(/\s+/, ' ')&.split(' ')&.last
      valid_year?(date_text) ? fallback_date_text : nil
    end

    def valid_year?(string)
      string&.match?(/^\d{4}$/)
    end

    def extract_image_src(a_tag)
      img = a_tag.at_css('img')
      return nil if a_tag.at_css('img')&.attribute_nodes&.find { |attr| attr.name == 'data-src' }

      img&.attribute_nodes&.find { |attr| attr.name == 'src' }&.value
    end
  end
end
