class Url < String
  attr_accessor :raw_url, :url

  def initialize(raw_url)
    self.raw_url = self.url = raw_url
  end

  def to_s
    ensure_protocol
    url
  end

  private
  def ensure_protocol
    self.url = ['http://', url].join unless has_protocol?
  end

  def has_protocol?
    url.split('://').size > 1
  end
end
