# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flow_node_patron/version'

Gem::Specification.new do |spec|
  spec.name          = 'flow_node_patron'
  spec.version       = FlowNodePatron::VERSION
  spec.authors       = ['atpking']
  spec.email         = ['atpking@gmail.com']

  spec.summary       = 'flow agent serve node patron '
  spec.description   = 'flow agent serve node patron '
  spec.homepage      = 'https://www.flow.ci'
  spec.license       = 'MIT'

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'awesome_print', '~> 1.7'
  spec.add_development_dependency 'byebug'

  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'byebug'

  spec.add_dependency 'rest-client', '~> 2.0'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'oj', '~> 2.18'
  spec.add_dependency 'aasm', '~> 4.12'
end
