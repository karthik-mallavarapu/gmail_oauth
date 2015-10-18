# gmail_oauth

[![Build Status](https://travis-ci.org/karthik-mallavarapu/gmail_oauth.svg?branch=master)](https://travis-ci.org/karthik-mallavarapu/gmail_oauth)
[![Coverage Status](https://coveralls.io/repos/karthik-mallavarapu/gmail_oauth/badge.svg?branch=master&service=github)](https://coveralls.io/github/karthik-mallavarapu/gmail_oauth?branch=master)
[![Code Climate](https://codeclimate.com/github/karthik-mallavarapu/gmail_oauth/badges/gpa.svg)](https://codeclimate.com/github/karthik-mallavarapu/gmail_oauth)

A convenient way to access gmail through oauth2 tokens. Supports fetching email uids, threaded email conversations, email messages, attachment downloads and attachment metadata.

For an introduction to Gmail's Oauth2 mechanism, refer to this [link](https://developers.google.com/gmail/xoauth2_protocol)

## Installation

Add this line to your application's Gemfile:

    gem 'gmail_oauth2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gmail_oauth2
    
## Features
    * Authenticate gmail sessions using gmail oauth2 access tokens.
    * Read emails from any mailbox.
    * Read emails based on last read email UID. Helps synchronize local email repositories with your gmail mailbox.
    * Read emails as threaded conversations.
    * Download attachments. Query attachments for meta data like file name, mime type, file extension etc.

## Usage

```ruby
require 'gmail_oauth'

# Authenticate a session using your gmail id and gmail oauth2 access token
gmail = GmailOauth.authenticate(email, access_token)

# Select a mailbox to search and/or read emails.
gmail.select # By default, INBOX is selected
```

### Fetch emails

```ruby
# Returns all UIDs in the selected mailbox
gmail.get_uids

# Returns UIDs of the emails arrived since the given UID
gmail.get_uids(4) # Returns the UIDs for emails after the UID 4. 

# Given an array of UIDs, returns an array of email objects.
gmail.fetch_emails(uids)
```

### Fetch threaded emails
Fetch emails as threaded conversations as ordered by gmail. 

```ruby
# Given an array of email UIDs, their respective thread ids are returned.
thread_ids = gmail.get_thread_ids(uids)

# Read emails from a given thread. 
messages = gmail.fetch_threaded_emails(thread_id) 
```

### Read emails and attachments
Emails are parsed and returned as objects of GmailOauth::Message class.
```ruby
messages = gmail.fetch_emails([1])
message = messages.first

# Read email attributes
message.to # To address field
message.from # From address field
message.cc # CC address field
message.subject # Subject

# Read text and HTML body
message.body_text # Text part of body if available
message.body_html # HTML part of body if available

# Query if email has attachments
message.has_attachments? # Returns true of false

# Access attachments
message.attachments # Returns an array of Attachment objects.
attachment = message.attachments.first
attachment.file_name # Attachment file name.
attachment.content # Attachment content. Save the attachment by simply writing the content to an open file handle
attachment.mime_type # Mime type of attachment based on the file contents. Uses mimemagic gem to read mime types.
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gmail_oauth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
