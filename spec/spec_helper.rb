# load lib in LOAD_PATH
$LOAD_PATH << File.join(File.dirname(__FILE__), '../lib')

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'rspec'

require 'mocha/api'
require 'aws-sdk-sns'
require 'exception_notifier'

ExceptionNotifier.testing_mode!

RSpec.configure do |config|
end
