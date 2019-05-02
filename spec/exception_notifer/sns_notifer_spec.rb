require 'spec_helper'
require 'exception_notifier/sns_notifier'

describe 'SNS Notifier' do
  let(:client_options) do
    {
      access_key_id: 'acces_key',
      secret_access_key: 'secret_access_key',
      region: 'region'
    }
  end

  let(:options) do
    {
      topic_arn: 'topic_arn',
      subject: 'notification_subject'
    }.merge(client_options)
  end

  let(:test_options) { {stub_responses: true }.merge(client_options) }

  before do
    expect(Aws::SNS::Client).to receive(:new).with(client_options).and_return(Aws::SNS::Client.new(test_options))
  end

  subject { ExceptionNotifier::SnsNotifier.new(options) }

  it 'should send exception notification to sns if properly configured' do
    subject.call(fake_exception)
  end

  it 'should compose correct message' do
    subject.call(fake_exception)

    composed_info = subject.compose_info
    expect(composed_info).to eq fake_info

    composed_message = subject.compose_message
    expect(composed_message[:backtrace]).not_to be_nil
    expect(composed_message[:default]).not_to be_nil
  end

  private

  def fake_message
    {
      backtrace: fake_exception.backtrace.to_s,
      default: fake_subject
    }
  end

  def fake_info
    info = " (#{fake_exception.class})"
    info << " #{fake_exception.message.inspect}"
  end

  def fake_exception
    5 / 0
  rescue StandardError => e
    e
  end
end
