require "gmail_oauth/version"
require "gmail_oauth/gmail_imap_extensions"

class GmailOauth

  attr_reader :imap, :email

  def initialize(email, access_token)
    @imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil,·verify = false)
    @email = email
    imap.authenticate('XOAUTH2', email, access_token)
    GmailImapExtensions.patch_net_imap_response_parser imap.
      instance_variable_get("@parser").singleton_class
  end

  def select_mailbox(mailbox='INBOX')
    imap.select(mailbox)
  end
end
