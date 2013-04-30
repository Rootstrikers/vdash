require 'open-uri'

class RemoteLink
  attr_accessor :url, :document

  # Throws SocketError if URL cannot be resolved. Not sure about timeouts.
  def initialize(url)
    self.url = Url.new(ResolvedUrl.new(url).to_s)
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

  class ResolvedUrl
    attr_accessor :url, :attempts

    def initialize(url)
      self.url      = url
      self.attempts = 0
    end

    def to_s
      resolve_url
      url
    end

    def resolve_url
      while ((response = Net::HTTP.get_response(URI(url))).is_a? Net::HTTPRedirection)
        self.attempts += 1
        self.url = response['location']
        break if attempts == 10
      end
    end
  end
end
