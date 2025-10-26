# Add the local lib directory to Ruby's search path
$LOAD_PATH.unshift(File.expand_path('./barcode_qr/lib', __dir__))

# Now this will work
require 'barcode_qr'

# Generate QR
qr = BarcodeQr::QrCode.new("Hello, World!")
qr.to_png("qr.png")
qr.to_svg("qr.svg")
puts "QR generated. Valid: #{qr.valid?}"


# Generate Barcode
bar = BarcodeQr::BarCode.new("590123412345")
bar.to_png("bar.png")
bar.to_svg("bar.svg")
puts "Barcode generated. Valid: #{bar.valid?}"

puts "Waiting for files to write..."
sleep 0.5 # Wait for half a second

# Decode
decoded_qr = BarcodeQr::Decoder.decode("qr.png")
puts "Decoded QR: #{decoded_qr}"

decoded_bar = BarcodeQr::Decoder.decode("bar.png")
puts "Decoded Barcode: #{decoded_bar}"

# Cleanup
File.delete("qr.png")
File.delete("qr.svg")
File.delete("bar.png")
File.delete("bar.svg")