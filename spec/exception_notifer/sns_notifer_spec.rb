require 'spec_helper'
require 'exception_notifier/sns_notifier'

describe 'SNS Notifer' do

  before(:each) do
    options = {
        access_key_id: 'acces_key',
        secret_access_key: 'secret_access_key',
        topic_arn: 'topic_arn',
        region: 'region'
    }

    @sns = ExceptionNotifier::SnsNotifier.new(options)
  end

  it 'should send exception notification to sns if properly configured' do
    @sns.call(fake_exception)
  end

  it 'should compose correct message and subject' do
    @sns.call(fake_exception)

    composed_info = @sns.compose_info
    expect(composed_info).to eq fake_info

    composed_message = @sns.compose_message
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
    begin
      5/0
    rescue Exception => e
      e
    end
  end


end