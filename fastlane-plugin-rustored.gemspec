lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/rustored/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-rustored'
  spec.version       = Fastlane::Rustored::VERSION
  spec.author        = '06ED'
  spec.email         = 'hsbest123@gmail.com'

  spec.summary       = 'Plugin for automating rustore publishing'
  spec.homepage      = "https://github.com/06ED/fastlane-rustored"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.7'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'
end
