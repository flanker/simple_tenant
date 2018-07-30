lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_tenant/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_tenant'
  spec.version       = SimpleTenant::VERSION
  spec.authors       = ["FENG Zhichao"]
  spec.email         = ["flankerfc@gmail.com"]

  spec.summary       = %q{A simple tenant lib for mongoid}
  spec.description   = %q{A simple tenant lib for mongoid}
  spec.homepage      = 'https://github.com/flanker/simple_tenant'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'request_store', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'mongoid'
  spec.add_development_dependency 'byebug'
end
