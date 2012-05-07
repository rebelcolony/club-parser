# -*- encoding: utf-8 -*-
require File.expand_path('../lib/**/*', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Nossoff"]
  gem.email         = ["kaluzhanin@gmail.com"]
  gem.description   = %q{This gem parses info about clubbing events}
  gem.summary       = %q{Club events parser}
  gem.homepage      = "http://wheretogoclubbing.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "club-parser"
  gem.require_paths = ["lib"]
  gem.version       = ClubParser::VERSION

  gem.add_dependency "nokogiri"
  gem.add_development_dependency "rspec"
end
