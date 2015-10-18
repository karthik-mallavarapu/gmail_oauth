require 'net/imap'
require 'mail'
require 'gmail_xoauth'
require 'mimemagic'
require 'mimemagic/overlay'
require 'gmail_oauth/version'
require 'gmail_oauth/gmail_imap_extensions'
require 'gmail_oauth/client'
require 'gmail_oauth/message'
require 'gmail_oauth/attachment'

module GmailOauth

  def self.authenticate(email, access_token)
    imap_client = Net::IMAP.new('imap.gmail.com', 993, usessl=true, certs=nil, verify=false)
    client = Client.new(imap_client, email, access_token)
    client.connect
    client
  end

end
