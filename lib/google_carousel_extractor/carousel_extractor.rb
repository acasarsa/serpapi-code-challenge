# frozen_string_literal: true

module GoogleCarouselExtractor
  # Processes the parsed data and extracts it into desired structure
  class CarouselExtractor
    def initialize(parser)
      @doc = parser.parse_html
    end

    def extract
      artworks = []

      a_tags = @doc.at_css('g-scrolling-carousel').css('a')
      a_tags.each do |a_tag|
        link = build_link(a_tag)
        image = extract_image_src(a_tag)
        title, date = extract_title_and_date(a_tag)
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

    def extract_title_and_date(a_tag)
      # TODO: the one that is missing a date is also showing empty for title. need to sort that out.
      inner_text = a_tag.text.strip.gsub(/\s+/, ' ').split
      date = extract_date(a_tag)
      title = inner_text[0...-1].join(' ')

      [title, date]
    end

    # TODO: use logger
    def extract_date(a_tag)
      date_element = a_tag.at_css('.ellip')
      if date_element
        date_text = date_element.text.strip
        return date_text if date_text.match?(/^\d+$/)
      end

      warn "Warning: Using fallback method to extract date. Check if 'ellip' class has changed or is missing."
      # TODO: this may need adjusting - it seemed different when i was in spec
      # Fallback: Extract the last word from the text content
      fallback_date = a_tag.text.strip.gsub(/\s+/, ' ').split(' ')[-1]
      fallback_date || 'Unknown Date' # Return 'Unknown Date' if no valid date is found
    end

    def extract_image_src(a_tag)
      img = a_tag.at_css('img')
      return nil if a_tag.at_css('img')&.attribute_nodes&.find { |attr| attr.name == 'data-src' }

      img&.attribute_nodes&.find { |attr| attr.name == 'src' }&.value
    end
  end
end
