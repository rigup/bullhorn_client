# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bullhorn_client/version'

Gem::Specification.new do |gem|
  gem.name          = "bullhorn_client"
  gem.version       = BullhornClient::VERSION
  gem.authors       = ["Dennis Kuczynski"]
  gem.email         = ["dennis.kuczynski@gmail.com"]
  gem.description   = %q{Example ruby client for Bullhorn ATS SOAP API}
  gem.summary       = %q{Example ruby client for Bullhorn ATS SOAP API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "savon"
  gem.add_dependency "active_attr"

  gem.add_development_dependency "rspec"
end
