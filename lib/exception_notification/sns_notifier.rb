module ExceptionNotifier
  class SnsNotifier < BaseNotifier
    include ExceptionNotifier::BacktraceCleaner

    def initialize(options)
      super
      access_key = options.delete(:access_key)
      secret_access_key = options.delete(:secret_access_key)
      region = options.delete(:region)
      @sns_client = AWS::SNS::Client.new(access_key: access_key, secret_access_key: secret_access_key, region: region)
      @topic_arn = options.delete(:topic_arn)
    end

    def call(exception, options={})
      return if !active?

      env = options[:env]
      @options = options
      @exception = exception
      @backtrace = exception.backtrace ? clean_backtrace(exception) : []
      @kontroller = env['action_controller.instance'] || MissingController.new
      @request = ActionDispatch::Request.new(env)

      message_json = {
          backtrace: @backtrace.to_s,
          request: {
              url:  @request.url,
              method:  @request.request_method,
              remote_ip: @request.remote_ip,
              parameters: @request.filtered_parameters.inspect
          },
          default: compose_subject
      }.to_json

      @sns_client.publish({
          subject: compose_subject,
          topic_arn: @topic_arn,
          message: message_json
      })
    end

    private

    def active?
      !@sns_client.nil?
    end

    def compose_subject
      subject = "#{@kontroller.controller_name}##{@kontroller.action_name}" if @kontroller
      subject << " (#{@exception.class})"
      subject << " #{@exception.message.inspect}"
    end
  end
end


