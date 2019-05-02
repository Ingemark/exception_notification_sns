require 'action_dispatch'

module ExceptionNotifier
  class SnsNotifier < BaseNotifier
    include ExceptionNotifier::BacktraceCleaner

    def initialize(options)
      super

      client_params = {}
      %i[access_key_id secret_access_key region].each do |key|
        next unless options[key].present?

        client_params[key] = options.delete(key)
      end

      @sns_client = Aws::SNS::Client.new(client_params)
      @topic_arn = options.delete(:topic_arn)
      @subject = options.delete(:subject)
    end

    def call(exception, options = {})
      return unless active?

      env = options[:env] || {}
      @options = options
      @exception = exception
      @backtrace = exception.backtrace ? clean_backtrace(exception) : []
      @kontroller = env['action_controller.instance']
      @request = ::ActionDispatch::Request.new(env) if @kontroller

      @sns_client.publish(topic_arn: @topic_arn, message: compose_message.to_json, subject: @subject)
    end

    def active?
      !@sns_client.nil? && @topic_arn.present?
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
      message[:request] = request_data if @request

      message
    end

    def request_data
      {
        url: @request.url,
        method: @request.request_method,
        remote_ip: @request.remote_ip,
        parameters: @request.filtered_parameters.inspect
      }
    end
  end
end
