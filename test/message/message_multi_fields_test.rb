require 'test_helper'
require 'gmail_oauth/message'

class MessageMultiFieldsTest < MiniTest::Test

  def setup
    @mail = Mail.read(fixture('multi_address.eml'))
    @message = GmailOauth::Message.new(@mail)
    @actual_data = YAML.load_file(fixture('multi_address.yml'))
  end

  def test_multi_to_addresses
    assert_equal @message.to, @actual_data['to']
  end

  def test_multi_cc_addresses

  end
end
