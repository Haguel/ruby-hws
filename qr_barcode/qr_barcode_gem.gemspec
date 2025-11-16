Gem::Specification.new do |s|
  s.name        = 'qr_barcode_gem'
  s.version     = '0.1.0'
  s.summary     = 'Gem for generating, validating, and decoding barcodes and QR codes in PNG/SVG'
  s.description = 'A simple Ruby gem to handle barcodes and QR codes: generation in PNG/SVG, validation, and decoding from images.'
  s.authors     = ['Grok AI']
  s.email       = 'example@email.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://example.com'
  s.license     = 'MIT'

  s.add_dependency 'rqrcode', '~> 2.0'
  s.add_dependency 'barby', '~> 0.6'
  s.add_dependency 'chunky_png', '~> 1.4'
  s.add_dependency 'zbar', '~> 0.2'

  s.add_development_dependency 'minitest', '~> 5.0'
end