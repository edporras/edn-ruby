# -*- encoding: utf-8 -*-
require File.expand_path('../lib/edn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Clinton N. Dreisbach & Russ Olsen. Ragel parser by Ed Porras."]
  gem.email         = ["russ@russolsen.com"]
  gem.description   = %q{'edn implements a reader for Extensible Data Notation by Rich Hickey.'}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/relevance/edn-ruby"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\).select { |val| !val.match(/native_parser/) }
  gem.extensions    = ['ext/edn_ext/extconf.rb']

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "edn_ext"
  gem.require_paths = ["lib"]
  gem.version       = EDN::VERSION

  gem.add_development_dependency 'pry', '~> 0.9.10'
  gem.add_development_dependency 'rspec', '~> 2.11.0'
  gem.add_development_dependency 'rantly', '~> 0.3.1'
  gem.add_dependency 'rake', '~> 10.0'
  gem.add_dependency 'rake-compiler', '~> 0.9'
end
