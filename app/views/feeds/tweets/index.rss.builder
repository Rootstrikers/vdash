xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Rootstrikers Twitter Feed"
    xml.description "Volunteer-submitted Tweets"
    xml.link links_url

    for tweet in @tweets
      xml.item do
        xml.title tweet.body[0..100]
        xml.description tweet.body
        xml.link tweet.link.url
        xml.pubDate tweet.posts.last.created_at.to_s(:rfc822)
      end
    end
  end
end
