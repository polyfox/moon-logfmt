require 'date'
require_relative 'lib/moon-logfmt/version'

Gem::Specification.new do |s|
  s.name        = 'moon-logfmt'
  s.summary     = 'An implementation of Logfmt encoding.'
  s.description = 'An implementation of Logfmt encoding in ruby.'
  s.homepage    = 'https://github.com/polyfox/moon-logfmt'
  s.email       = 'mistdragon100@gmail.com'
  s.version     = Moon::Logfmt::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.to_date.to_s
  s.license     = 'MIT'
  s.authors     = ['Blaž Hrastnik', 'Corey Powell']

  s.add_dependency             'moon-null_io',  ['>= 1.0.1', '~> 1.0']
  s.add_development_dependency 'rake',          '>= 11.0'
  s.add_development_dependency 'rubocop',       '~> 0.49'
  s.add_development_dependency 'guard',         '~> 2.8'
  s.add_development_dependency 'yard',          '~> 0.9.12'
  s.add_development_dependency 'rspec',         '~> 3.2'
  s.add_development_dependency 'simplecov'

  s.require_path = 'lib'
  s.files = []
  s.files += Dir.glob('lib/**/*.{rb,yml}')
  s.files += Dir.glob('spec/**/*')
end
