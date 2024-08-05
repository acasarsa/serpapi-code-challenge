# frozen_string_literal: true

require 'base64'
require 'mini_magick'

module ImageHelpers
  def decode_base64_image(base64_string)
    base64_data = base64_string&.split(',')&.[](1)
    Base64.decode64(base64_data)
  end

  def strip_metadata(image_data)
    image = MiniMagick::Image.read(image_data)
    image.strip
    image.to_blob
  end

  def process_base64_image(base64_string)
    decoded_image = decode_base64_image(base64_string)
    strip_metadata(decoded_image)
  end
end

module ArtworkComparisonHelpers
  include ImageHelpers

  def compare_artworks_handling_nil_image_cases(extracted, expected)
    extracted.each_with_index do |artwork, index|
      compare_artwork_details(artwork, expected[index])
      compare_artwork_images_handling_nil_cases(artwork, expected[index])
    end
  end

  private

  def compare_artwork_details(artwork, expected_artwork)
    expect(artwork['name']).to eq(expected_artwork['name'])
    expect(artwork['link']).to eq(expected_artwork['link'])
    expect(artwork['extensions']).to eq(expected_artwork['extensions'])
  end

  def compare_artwork_images_handling_nil_cases(artwork, expected_artwork)
    return if artwork['image'].nil? || expected_artwork['image'].nil? # Nil image handling

    expect(process_base64_image(artwork['image'])).to eq(
      process_base64_image(expected_artwork['image'])
    )
  end
end
