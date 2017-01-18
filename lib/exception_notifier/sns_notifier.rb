require 'action_dispatch'

module ExceptionNotifier
  class SnsNotifier < BaseNotifier
    include ExceptionNotifier::BacktraceCleaner

    def initialize(options)
      super
      access_key_id = options.delete(:access_key_id)
      secret_access_key = options.delete(:secret_access_key)
      region = options.delete(:region)

      @sns_client = AWS::SNS::Client.new(access_key_id: access_key_id, secret_access_key: secret_access_key, region: region)
      @topic_arn = options.delete(:topic_arn)
    end

    def call(exception, options={})
      return if !active?



      env = options[:env] || {}
      puts env.inspect
      @options = options
      @exception = exception
      @backtrace = exception.backtrace ? clean_backtrace(exception) : []
      @kontroller = env['action_controller.instance']
      @request = ::ActionDispatch::Request.new(env) if @kontroller

      @sns_client.publish({
          subject: compose_subject,
          topic_arn: @topic_arn,
          message: compose_message.to_json
      })
    end

    def active?
      !@sns_client.nil? && !@topic_arn.nil?
    end

    def compose_subject
      subject = @kontroller ? "#{@kontroller.controller_name}##{@kontroller.action_name}" : ''
      subject << " (#{@exception.class})"
      subject << " #{@exception.message.inspect}"
    end

    def compose_message
      message = {
          backtrace: @backtrace.to_s,
          default: compose_subject
      }

      message[:request] = {
          url:  @request.url,
          method:  @request.request_method,
          remote_ip: @request.remote_ip,
          parameters: @request.filtered_parameters.inspect
      } if @request

      message
    end
  end
end


