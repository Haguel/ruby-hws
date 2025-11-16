# frozen_string_literal: true

require 'chunky_png'

module QrBarcodeGem
  class Decoder
    # Decode from an image
    def self.decode(image_path)
      image = if image_path.end_with?('.png')
                # Use ChunkyPNG to convert to PGM (a format that ZBar understands).
                png = ChunkyPNG::Image.from_file(image_path)

                # Convert pixels to grayscale
                gray_pixels = png.pixels.map do |pixel|
                  r = ChunkyPNG::Color.r(pixel)
                  g = ChunkyPNG::Color.g(pixel)
                  b = ChunkyPNG::Color.b(pixel)
                  ((r + g + b) / 3).to_i # Average for brightness
                end

                # Create PGM (P5 binary) header and data
                # P5 - binary grayscale image format
                pgm_data = "P5\n#{png.width} #{png.height}\n255\n" + gray_pixels.pack('C*')

                ZBar::Image.from_pgm(pgm_data)
              elsif image_path.end_with?('.jpg') || image_path.end_with?('.jpeg')
                file_data = File.read(image_path)
                ZBar::Image.from_jpeg(file_data)
              else
                raise ArgumentError, "Unsupported image format"
              end

      symbols = image.process
      symbols.map { |s| { data: s.data, type: s.symbology } }
    end
  end
end
