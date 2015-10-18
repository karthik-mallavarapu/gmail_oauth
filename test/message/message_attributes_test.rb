require 'test_helper'
require 'gmail_oauth/message'

class MessageAttributesTest < Minitest::Test

  def setup
    @mail = Mail.read(fixture('base.eml'))
    @message = GmailOauth::Message.new(@mail)
    @actual_data = YAML.load_file(fixture('base.yml'))
  end

  def test_message_init
    assert_equal @message.class, GmailOauth::Message
  end

  def test_message_headers
    assert_equal @message.to.first, @actual_data['to']
    assert_equal @message.from.first, @actual_data['from']
    assert_equal @message.subject, @actual_data['subject']
    assert_equal @message.received_on, DateTime.parse(@actual_data['received_on'])
  end

  def test_message_body
    assert_equal @message.body_text.gsub(/[\r\n]/, ''), 
      @actual_data['body_text'].gsub(/[\r\n]/, '')
    assert_equal @message.body_html, @actual_data['body_html']
  end

  def test_has_attachment
    refute @message.has_attachments?
  end
end
