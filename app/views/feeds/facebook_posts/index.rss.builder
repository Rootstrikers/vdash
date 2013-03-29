xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Rootstrikers Facebook Feed"
    xml.description "Volunteer-submitted Facebook Posts"
    xml.link links_url

    for post in @posts
      xml.item do
        xml.title post.body[0..100]
        xml.description post.body
        xml.link post.link.url
        xml.pubDate post.posts.last.created_at.to_s(:rfc822)
      end
    end
  end
end
