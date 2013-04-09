require 'open-uri'

class RemoteLink

  attr_accessor :url, :document

  def initialize(url)
    self.url      = url
    self.document = Nokogiri::HTML(open url)
  end

  def title
    document.title
  end

  def first_paragraph
    document.xpath('//p').first.try(:text)
  end
end
