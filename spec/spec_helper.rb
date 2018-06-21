# load lib in LOAD_PATH
$LOAD_PATH << File.join(File.dirname(__FILE__), '../lib')

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'rspec'

require 'mocha/api'
require 'aws/sns'
require 'exception_notifier'

ExceptionNotifier.testing_mode!
AWS.stub!

RSpec.configure do |config|
end
