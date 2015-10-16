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
end
