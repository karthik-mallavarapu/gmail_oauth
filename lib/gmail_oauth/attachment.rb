class GmailOauth::Attachment

  attr_reader :content, :mime_type, :file_name

  def initialize(attachment)
    @file_name = attachment.filename
    @content = attachment.body.decoded
  end

  def file_extension
    @file_name.split(".").last
  end

  def mime_type
  end
end
