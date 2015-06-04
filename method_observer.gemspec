# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'method_observer'

Gem::Specification.new do |spec|
  spec.name          = 'method_observer'
  spec.version       = MethodObserver::VERSION
  spec.authors       = ['Gabriel Naiman']
  spec.email         = ['gabynaiman@gmail.com']
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.homepage      = 'https://github.com/gabynaiman/method_observer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry-nav'
end
