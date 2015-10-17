class GmailOauth::Client

  attr_reader :imap, :email, :access_token

  # Initialize a new imap session and authenticate using the oauth2 access
  # token.
  def initialize(imap_client, email_param, access_token_param)
    @imap = imap_client
    @email = email_param
    @access_token = access_token_param
    GmailOauth::GmailImapExtensions.patch_net_imap_response_parser imap.
      instance_variable_get("@parser").singleton_class
  end

  def connect
    imap.authenticate('XOAUTH2', email, access_token)
  end

  # Select appropriate mailbox. Ex: 'INBOX', '[Gmail]/All Mail',
  # '[Gmail]/Drafts', '[Gmail]/Spam', '[Gmail]/Trash', '[Gmail]/Starred' 
  def select_mailbox(mailbox='INBOX')
    imap.select(mailbox)
  end

  def get_uids(last_seen_uid=0)
    imap.uid_search(search_param(last_seen_uid))
  end

  def fetch_emails(uids, &block)
    messages = Array.new
    uids.each_slice(10) do |grp|
      connect if imap.disconnected?
      emails = imap.uid_fetch(grp.compact, 'RFC822')
      emails.each do |email|
        message = GmailOauth::Message.new(Mail.
                  read_from_string(email.attr['RFC822']), email.attr['UID']) 
        yield(message) if block_given?
        messages << message
      end
    end
    messages
  end

  def fetch_threaded_emails(uids, &block)
    thread_responses = imap.uid_fetch(uids, '(X-GM-THRID)')
    thread_ids = thread_responses.map { |t| t.attr['X-GM-THRID'] }
    thread_ids.each do |thread_id|
      thread_email_ids = imap.uid_search("X-GM-THRID #{thread_id}")
      messages = fetch_emails(thread_email_ids)
      yield(thread_id, messages) if block_given?
    end
  end

  private

  def search_param(last_seen_uid)
    return "ALL" if last_seen_uid == 0
    next_uid = last_seen_uid.to_i + 1
    return "UID #{next_uid}:*"
  end
end
