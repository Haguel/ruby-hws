module QrBarcodeGem
  class Decoder
    # Декодування з зображення (підтримує JPEG/PNG, якщо ZBar скомпільовано з підтримкою)
    def self.decode(image_path)
      file_data = File.read(image_path)
      image = if image_path.end_with?('.png')
                ZBar::Image.from_png(file_data)
              elsif image_path.end_with?('.jpg') || image_path.end_with?('.jpeg')
                ZBar::Image.from_jpeg(file_data)
              else
                raise ArgumentError, "Unsupported image format"
              end
      symbols = image.process
      symbols.map { |s| { data: s.data, type: s.symbology } }
    end
  end
end