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
      @options = options
      @exception = exception
      @backtrace = exception.backtrace ? clean_backtrace(exception) : []
      @kontroller = env['action_controller.instance']
      @request = ::ActionDispatch::Request.new(env) if @kontroller

      @sns_client.publish({
                              topic_arn: @topic_arn,
                              message: compose_message.to_json
                          })
    end

    def active?
      !@sns_client.nil? && !@topic_arn.nil?
    end

    def compose_info
      info = @kontroller ? "#{@kontroller.controller_name}##{@kontroller.action_name}" : ''
      info << " (#{@exception.class})"
      info << " #{@exception.message.inspect}"
    end

    def compose_message
      message = {
          info: compose_info,
          backtrace: @backtrace.to_s,
          default: compose_info
      }

      message[:request] = {
          url: @request.url,
          method: @request.request_method,
          remote_ip: @request.remote_ip,
          parameters: @request.filtered_parameters.inspect
      } if @request

      message
    end
  end
end


