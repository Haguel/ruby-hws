require 'minitest/autorun'
require 'qr_barcode_gem'

class TestValidator < Minitest::Test
  def test_validate_qr_valid
    assert QrBarcodeGem::Validator.validate_qr('Hello')
  end

  def test_validate_qr_invalid
    refute QrBarcodeGem::Validator.validate_qr('' * 10000) # Занадто довге
  end

  def test_validate_barcode_valid
    assert QrBarcodeGem::Validator.validate_barcode('12345', type: :code_128)
  end

  def test_validate_barcode_invalid
    refute QrBarcodeGem::Validator.validate_barcode('invalid@', type: :ean_13)
  end
end