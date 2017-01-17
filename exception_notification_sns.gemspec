# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'exception_notification_sns'
  s.version     = '0.1.0'
  s.summary     = 'exception_notification extension for aws sns v1'
  s.description = 'exception_notification extension for aws sns v1'
  s.required_ruby_version = '>= 2.2.0'

  s.author    = 'Matej Minažek'
  s.email     = 'matej.minazek@ingemark.com'
  s.homepage  = 'http://www.ingemark.com'
  s.license   = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'

  s.add_runtime_dependency 'exception_notification', '4.2.1'
  s.add_runtime_dependency 'aws-sdk-v1', '1.66'

  s.add_development_dependency 'factory_girl', '4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '3.1.0'
  s.add_development_dependency 'sqlite3', '1.3.10'
  s.add_development_dependency 'poltergeist', '1.10'
  s.add_development_dependency 'simplecov', '0.9.0'
  s.add_development_dependency 'database_cleaner', '1.5'
  s.add_development_dependency 'coffee-rails', '4.0.0'
  s.add_development_dependency 'sass-rails', '5.0.0'
end
