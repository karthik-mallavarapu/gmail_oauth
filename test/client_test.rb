require 'test_helper'
require 'gmail_oauth'
require 'gmail_oauth/client'

class ClientTest < Minitest::Test

  def setup
    @imap = Minitest::Mock.new
    @imap.expect :instance_variable_get, true, ["@parser"]
    @client = GmailOauth::Client.new(@imap, "sampleuser@gmail.com", "samplepass") 
  end

  def test_imap_connect
    @imap.expect :authenticate, true, ['XOAUTH2', "sampleuser@gmail.com", "samplepass"]
    assert_equal @client.connect, true
  end

  # select_mailbox method must select INBOX by default if no mailbox is specified
  def test_select_mailbox
    @imap.expect :select, true, ["INBOX"]
    @client.select_mailbox
    assert @imap.verify
  end

  # get_uids method must return all uids, if no argument is passed
  def test_uid_search_all
    @imap.expect :uid_search, [1,2,3,4], ["ALL"]
    @client.get_uids
    assert @imap.verify
  end

  # get_uids must return uids greater than the last seen uid
  def test_uid_search_last_seen_uid
    @imap.expect :uid_search, [2,3,4], ["UID 2:*"]
    @client.get_uids(1)
    assert @imap.verify
  end

  # get_uids method searches for the right uid_search string even when last_seen
  # uid is a string
  def test_uid_search_last_seen_uid_str
    @imap.expect :uid_search, [2,3,4], ["UID 2:*"]
    @client.get_uids('1')
    assert @imap.verify
  end

  def test_fetch_emails_connect_if_disconnected
    @imap.expect :disconnected?, true 
    @imap.expect :authenticate, true, ['XOAUTH2', "sampleuser@gmail.com", "samplepass"]
    @imap.expect :uid_fetch, [], [[2,3,4], 'RFC822']
    @client.fetch_emails([2,3,4])
    assert @imap.verify
  end

  def test_fetch_emails
    mock_email = Minitest::Mock.new
    # Expectations must be defined as many times as the method calls.
    mock_email.expect :attr, {'RFC822' => File.read(fixture('base.eml')), 'UID' => '1'}, []
    mock_email.expect :attr, {'RFC822' => File.read(fixture('base.eml')), 'UID' => '1'}, []
    @imap.expect :uid_fetch,[mock_email], [[1], 'RFC822']
    @imap.expect :disconnected?, false 
    actual_data = YAML.load_file(fixture('base.yml'))
    emails = @client.fetch_emails([1])
    assert emails[0].class, GmailOauth::Message
    assert emails[0].uid, 1
    assert emails[0].to.first, actual_data['to']
    assert emails[0].from.first, actual_data['from']
    assert emails[0].subject, actual_data['subject']
  end
end
