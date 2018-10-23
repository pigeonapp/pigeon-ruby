
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pigeon/version'

Gem::Specification.new do |spec|
  spec.name          = 'pigeon-ruby'
  spec.version       = Pigeon::VERSION
  spec.authors       = ['Pradeep Kumar']
  spec.email         = ['pradeep@keepworks.com']

  spec.summary       = %q{Pigeon Ruby Library}
  spec.description   = %q{Pigeon lets you easily manage your outbound email, push notifications and SMS. Visit https://pigeonapi.io for more details.}
  spec.homepage      = 'https://pigeonapp.io'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'httparty', '~> 0.16'
end
