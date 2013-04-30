require 'open-uri'

class RemoteLink
  attr_accessor :url, :document

  # Throws SocketError if URL cannot be resolved. Not sure about timeouts.
  def initialize(url)
    self.url = Url.new(resolved_url(url))
    complain_if_bad_url
    self.document = Nokogiri::HTML(open url.to_s) rescue nil
  end

  def title
    document.try(:title)
  end

  def first_paragraph
    document.try(:xpath, '//p').try(:first).try(:text)
  end

  def as_json
    {
      title:           title,
      first_paragraph: first_paragraph
    }
  end

  private
  def complain_if_bad_url
    unless url.valid?
      puts "Invalid url: #{url.try(:to_s)}"
      raise "Invalid URL"
    end
  end

  def resolved_url(url)
    ResolvedUrl.new(url).to_s rescue url
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
      begin
        while ((response = Net::HTTP.get_response(URI(url))).is_a? Net::HTTPRedirection)
          self.attempts += 1
          self.url = response['location']
          break if attempts == 10
        end
      rescue SocketError, RuntimeErorr
        Rails.logger.warn "Caught exception when trying to fetch #{url}"
      end
    end
  end
end
