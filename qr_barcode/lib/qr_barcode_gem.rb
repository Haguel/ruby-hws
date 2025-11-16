require 'rqrcode'
require 'barby'
require 'barby/outputter/png_outputter'
require 'barby/outputter/svg_outputter'
require 'barby/barcode/ean_13'
require 'barby/barcode/code_128'
require 'zbar'

module QrBarcodeGem
  # Головний модуль
end

require_relative 'qr_barcode_gem/generator'
require_relative 'qr_barcode_gem/decoder'
require_relative 'qr_barcode_gem/validator'