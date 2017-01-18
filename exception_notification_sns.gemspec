# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'exception_notification_sns'
  s.version     = '0.1.0'
  s.summary     = 'exception_notification extension for aws sns v1'
  s.description = 'exception_notification_sns gem is used for sending application extensions to aws sns. It extends exception_notification gem, uses aws-sdk-v1 gem to push exception notificatons to amazon sns'
  s.required_ruby_version = '>= 2.2.0'

  s.author    = 'Matej Minažek'
  s.email     = 'matej.minazek@ingemark.com'
  s.homepage  = 'http://www.ingemark.com'
  s.license   = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'

  s.add_runtime_dependency 'exception_notification', '4.2.1'
  s.add_runtime_dependency 'aws-sdk-v1', '>= 1'

  s.add_development_dependency 'rails', '>= 4.0.0', '< 6'
  s.add_development_dependency 'aws-sdk-v1', '1.66'
  s.add_development_dependency 'factory_girl', '4.5'
  s.add_development_dependency 'rspec', '3.4.0'
  s.add_development_dependency 'mocha', '~> 0.13.0'
  s.add_development_dependency 'sqlite3', '1.3.10'
  s.add_development_dependency 'coveralls', '~> 0.8.2'

end
