module QrBarcodeGem
  class Generator
    # Генерація QR-коду
    def self.generate_qr(data, format: :png, options: {})
      qr = RQRCode::QRCode.new(data)
      case format
      when :png
        qr.as_png(options)
      when :svg
        qr.as_svg(options)
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end

    # Генерація штрих-коду (підтримувані типи: :code_128, :ean_13, etc.)
    def self.generate_barcode(data, type: :code_128, format: :png)
      barcode_class = case type
                      when :code_128 then Barby::Code128B
                      when :ean_13 then Barby::EAN13
                      # Додайте інші типи за потребою
                      else raise ArgumentError, "Unsupported type: #{type}"
                      end
      barcode = barcode_class.new(data)
      case format
      when :png
        Barby::PngOutputter.new(barcode).to_png
      when :svg
        Barby::SvgOutputter.new(barcode).to_svg
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end
  end
end