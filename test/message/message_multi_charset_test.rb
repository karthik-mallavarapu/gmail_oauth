require 'test_helper'
require 'gmail_oauth/message'

class MessageMultiCharsetTest < MiniTest::Test

  def setup
    @mail = Mail.read(fixture('multi_charset.eml'))
    @message = GmailOauth::Message.new(@mail)
    @actual_data = YAML.load_file(fixture('multi_charset.yml'))
  end

  def test_utf8_subject
    assert_equal @message.subject.gsub("\n", ''), @actual_data['subject'].gsub("\n", '')
  end

  def test_utf8_body_text
    assert_equal @message.body_text.gsub(/[\r\n]/, ''), 
      @actual_data['body_text'].gsub(/[\r\n]/, '')
  end

  def test_utf8_body_html
    assert_equal @message.body_html, @actual_data['body_html']
  end
end
