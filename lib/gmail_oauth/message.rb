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

  ["text", "html"].each do |format|
    define_method("body_#{format}") do 
      return nil unless email.send("#{format}_part")
      body = email.send("#{format}_part").body.raw_source
      decoded_text = Mail::Encodings.decode_encode(body, 'UTF-8')
      return Mail::Encodings.value_decode(decoded_text)
    end
  end

  def has_attachments?
    !email.attachments.blank?
  end

  def get_attachments
    return [] unless has_attachments?
    attachments = []
    email.attachments.each do |attach|
      attachments << GmailOauth::Attachment.new(attach) 
    end
    attachments
  end
end
