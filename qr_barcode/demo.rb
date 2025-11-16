$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'qr_barcode_gem'

# Генерація QR PNG та збереження
qr_png = QrBarcodeGem::Generator.generate_qr('https://example.com', format: :png)
File.write('qr.png', qr_png.to_s)
puts 'QR PNG згенеровано: qr.png'

# Генерація QR SVG
qr_svg = QrBarcodeGem::Generator.generate_qr('https://example.com', format: :svg)
File.write('qr.svg', qr_svg)
puts 'QR SVG згенеровано: qr.svg'

# Генерація штрих-коду PNG
barcode_png = QrBarcodeGem::Generator.generate_barcode('123456789012', type: :ean_13, format: :png)
File.write('barcode.png', barcode_png)
puts 'Barcode PNG згенеровано: barcode.png'

# Генерація штрих-коду SVG
barcode_svg = QrBarcodeGem::Generator.generate_barcode('123456789012', type: :ean_13, format: :svg)
File.write('barcode.svg', barcode_svg)
puts 'Barcode SVG згенеровано: barcode.svg'

# Валідація
puts "QR валідація: #{QrBarcodeGem::Validator.validate_qr('Valid data')}" # true
puts "Barcode валідація: #{QrBarcodeGem::Validator.validate_barcode('1234567890', type: :ean_13)}" # true

# Декодування (використовуємо згенерований QR PNG)
decoded = QrBarcodeGem::Decoder.decode('qr.png')
puts "Декодовано: #{decoded.first[:data]} (тип: #{decoded.first[:type]})"