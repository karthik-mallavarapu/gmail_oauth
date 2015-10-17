class GmailOauth::Message

  attr_reader :uid, :email, :subject, :to, :from, :cc, :received_on

  def initialize(email, uid = 0)
    @email = email
    @uid = uid
    @to = email.to
    @from = email.from
    @subject = email.subject
    @cc = email.cc
    @received_on = email.date
  end

  def body_text
    return nil unless email.html_part
    text = email.text_part.body.to_s
    decoded_text = Mail::Encodings.decode_encode(text, 'UTF-8')
    return Mail::Encodings.value_decode(decoded_text)
  end

  def body_html
    return nil unless email.html_part
    html = email.html_part.body.to_s
    decoded_text = Mail::Encodings.decode_encode(html, 'UTF-8')
    return Mail::Encodings.value_decode(decoded_text)
  end

  def has_attachments?
    email.attachment?
  end

  def get_attachments
    return [] unless has_attachments?
    attachments = []
    email.attachments.each do |attach|
      attachments << Attachment.new(attach) 
    end
    attachments
  end
end
