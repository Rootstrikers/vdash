module Twitter
  class Fetcher
    attr_accessor :results

    def self.run
      new.run
    end

    def run
      find_unpublished_results
      publish_results
    end

    private
    def find_unpublished_results
      self.results = Search.run.select(&:unpublished?)
    end

    def publish_results
      Thread.current[:current_user] = User.twitter
      results.each { |result| Publisher.new(result).run }
    end

    class Publisher < Struct.new(:result)
      attr_accessor :link, :content

      def run
        publish_link
        return unless link.present?
        publish_content
        update_result
      end

      def publish_link
        return unless remote_link.present?
        self.link = existing_link || create_link
      end

      def publish_content
        self.content = existing_content || create_content
      end

      def existing_link
        Link.where(url: url.to_s).first
      end

      def create_link
        User.twitter.links.create(url: url.to_s, title: title, summary: summary, listable: false)
      end

      def existing_content
        link.present? ? link.contents.where(body: content_body).first : Content.where(body: content_body).first
      end

      def create_content
        User.twitter.contents.create(link: link, body: content_body)
      end

      def update_result
        result.update_attributes(link: link, content: content)
      end

      def content_body
        result.content_body
      end

      def remote_link
        @remote_link ||= RemoteLink.new(result.url) rescue nil
      end

      def url
        remote_link.try(:url)
      end

      def title
        remote_link.try(:title)
      end

      def summary
        remote_link.try(:first_paragraph)
      end
    end
  end
end
