require 'test_helper'
require 'gmail_oauth/message'

class MessageMultiAttachmentsTest < Minitest::Test

  def setup
    @mail = Mail.read(fixture('multi_attachments.eml'))
    @message = GmailOauth::Message.new(@mail)
    @actual_data = YAML.load_file(fixture('multi_attachments.yml'))
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
    assert_equal @message.has_attachments?, true
  end

  def test_get_attachments
    attachments = @message.get_attachments
    attachment_1, attachment_2 = attachments
    assert_equal attachments.count, 2
    # Assert attachment filenames
    assert_equal attachment_1.file_name, "sample.pdf"
    assert_equal attachment_2.file_name, "sample.docx"
    # Assert attachment mime types
    assert_equal attachment_1.mime_type, "application/pdf"
    assert_equal attachment_2.mime_type, "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  end
end
