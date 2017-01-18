# Exception notification SNS

Exception notification extension for Amazon SNS

## Requirements

* Ruby 2.2 or greater
* Rails 4.0 or greater

## Getting Started

Add the following line to your application's Gemfile:

```ruby
gem 'exception_notification_sns'
```

### Rails

ExceptionNotificationSNS adds sns notifier for exception_notification gem. It is used as a rack middleware, or in the environment you want it to run. In most cases you would want ExceptionNotificationSNS to run on production. Thus, you can make it work by putting the following lines in your `config/environments/production.rb`:

```ruby
Rails.application.config.middleware.use ExceptionNotification::Rack,
  sns: {
    access_key_id: 'AWS_ACCESS_KEY_ID',
    secret_access_key: 'AWS_SECRET_ACCESS_KEY',
    region: 'AWS_REGION',
    topic_arn: 'AWS_SNS_TOPIC_ARN'
  }
```

#### Options

##### access_key_id 

*String, required*

AWS access key ID

##### secret_access_key 

*String, required*

AWS secret access key

##### region

*String, required*

AWS region

##### topic_arn

*String, required*

AWS SNS topic arn

## Extras 

For more information about exception_notification gem on which this gem was built, visit [exception_notification](https://github.com/smartinez87/exception_notification).

## License

Copyright (c) 2017 Matej Minažek, released under the [MIT license](http://www.opensource.org/licenses/MIT).




