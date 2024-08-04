# frozen_string_literal: true

require 'base64'
require 'mini_magick'

module ImageHelpers
  def decode_base64_image(base64_string)
    base64_data = base64_string.split(',')[1]
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
