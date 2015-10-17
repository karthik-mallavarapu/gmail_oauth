require 'test_helper'
require 'gmail_oauth'
require 'gmail_oauth/attachment'

class AttachmentTest < Minitest::Test

  def setup
    @attachment_mock = Minitest::Mock.new
    @attachment_body = Minitest::Mock.new
    @attachment_mock.expect :body, @attachment_body
  end

  def test_attachment_attrs
    @attachment_mock.expect :filename, "sample.doc"
    @attachment_body.expect :decoded, "sampletext"
    attachment = GmailOauth::Attachment.new(@attachment_mock)
    assert_equal attachment.file_name, "sample.doc"
    assert_equal attachment.content, "sampletext"
    assert_equal attachment.file_extension, "doc"
  end

  def test_attachment_mime_type_doc
    @attachment_mock.expect :filename, "sample.doc"
    @attachment_body.expect :decoded, File.read(fixture('sample.doc'), 10000)
    attachment = GmailOauth::Attachment.new(@attachment_mock)
    assert_equal attachment.mime_type, "application/msword"
  end

  def test_attachment_mime_type_pdf
    @attachment_mock.expect :filename, "sample.pdf"
    @attachment_body.expect :decoded, File.read(fixture('sample.pdf'), 10000)
    attachment = GmailOauth::Attachment.new(@attachment_mock)
    assert_equal attachment.mime_type, "application/pdf"
  end

  def test_attachment_mime_type_docx
    @attachment_mock.expect :filename, "sample.docx"
    @attachment_body.expect :decoded, File.read(fixture('sample.docx'), 10000)
    attachment = GmailOauth::Attachment.new(@attachment_mock)
    assert_equal attachment.mime_type, "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  end
end
