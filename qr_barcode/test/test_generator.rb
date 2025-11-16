require 'minitest/autorun'
require 'qr_barcode_gem'

class TestGenerator < Minitest::Test
  def test_generate_qr_png
    png = QrBarcodeGem::Generator.generate_qr('Hello', format: :png)
    assert png.is_a?(ChunkyPNG::Image)
  end

  def test_generate_qr_svg
    svg = QrBarcodeGem::Generator.generate_qr('Hello', format: :svg)
    assert svg.include?('<svg')
  end

  def test_generate_barcode_png
    png = QrBarcodeGem::Generator.generate_barcode('12345', type: :code_128, format: :png)
    assert !png.empty?
  end

  def test_generate_barcode_svg
    svg = QrBarcodeGem::Generator.generate_barcode('12345', type: :code_128, format: :svg)
    assert svg.include?('<svg')
  end
end