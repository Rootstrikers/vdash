require 'open-uri'

class RemoteLink
  attr_accessor :url, :document

  # Throws SocketError if URL cannot be resolved. Not sure about timeouts.
  def initialize(url)
    self.url      = Url.new(url)
    complain_if_bad_url
    self.document = Nokogiri::HTML(open url.to_s)
  end

  def title
    document.title
  end

  def first_paragraph
    document.xpath('//p').first.try(:text)
  end

  def as_json
    {
      title:           title,
      first_paragraph: first_paragraph
    }
  end

  private
  def complain_if_bad_url
    raise "Invalid URL" unless url.valid?
  end
end
