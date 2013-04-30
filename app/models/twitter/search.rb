require 'open-uri'
require 'json'

module Twitter
  class Search
    attr_accessor :url, :contents

    DEFAULT_URL = "https://search.twitter.com/search.json?q=%23rootstrikers%20-from%3Arootstrikers%20-%22RT%20%40rootstrikers%22"

    def initialize(url = DEFAULT_URL)
      self.url = url
    end

    def fetch
      self.contents = JSON.parse(open(url).read)
    end

    def results
      contents['results'].map { |json| Result.from_json(json) }
    end
  end
end
