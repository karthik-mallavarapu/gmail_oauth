class GmailOauth::Attachment

  attr_reader :content, :mime_type, :file_name

  def initialize(attachment)
    @file_name = attachment.filename
    @content = attachment.body.decoded
    @mime_type = get_mime_type
  end

  def file_extension
    @file_name.split(".").last
  end

  def get_mime_type
    if mime_obj = MimeMagic.by_magic(content[0..10000])
      mime_obj.type
    end
  end
end
