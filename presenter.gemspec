# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'presenter/version'

Gem::Specification.new do |gem|
  gem.name          = 'presenter'
  gem.version       = Presenter::VERSION
  gem.authors       = ['Andrew Marshall']
  gem.email         = ['andrew@johnandrewmarshall.com']
  gem.description   = %q{A Simple presenter.}
  gem.summary       = %q{A Simple presenter.}
  gem.homepage      = 'http://johnandrewmarshall.com/projects/presenter'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
