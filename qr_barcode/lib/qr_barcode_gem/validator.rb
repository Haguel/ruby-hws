module QrBarcodeGem
  class Validator
    # Валідація даних для QR
    def self.validate_qr(data)
      RQRCode::QRCode.new(data)
      true
    rescue
      false
    end

    # Валідація даних для штрих-коду
    def self.validate_barcode(data, type: :code_128)
      barcode_class = case type
                      when :code_128 then Barby::Code128B
                      when :ean_13 then Barby::EAN13
                      else raise ArgumentError, "Unsupported type: #{type}"
                      end
      barcode_class.new(data)
      true
    rescue
      false
    end
  end
end