class Url
  attr_accessor :raw_url, :url

  def initialize(raw_url)
    self.raw_url = self.url = raw_url
    ensure_protocol if url.present?
  end

  def to_s
    return url if url.blank?

    url
  end

  def valid?
    uri = URI.parse(url)
    looks_valid?
  rescue URI::InvalidURIError
    false
  end

  private
  def ensure_protocol
    self.url = ['http://', url].join unless has_protocol?
  end

  def has_protocol?
    url.split('://').size > 1
  end

  def looks_valid?
    url =~ URI::regexp and url.include?('.')
  end
end
