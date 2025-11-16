require 'minitest/autorun'
require 'qr_barcode_gem'
require 'tempfile'

class TestDecoder < Minitest::Test
  def test_decode_qr
    # Генеруємо тимчасовий PNG для тесту
    png = QrBarcodeGem::Generator.generate_qr('Test data', format: :png)
    Tempfile.create(['test', '.png']) do |f|
      f.write(png.to_s)
      f.rewind
      results = QrBarcodeGem::Decoder.decode(f.path)
      assert_equal 1, results.size
      assert_equal 'Test data', results.first[:data]
    end
  end
end