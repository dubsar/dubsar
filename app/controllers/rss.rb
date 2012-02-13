require 'open-uri'
module Rss
  class Feed
    attr_accessor :title, :date, :enclosure
    def self.parse(url)
      feed = Feed.new
      rss = Nokogiri::XML(open(url))
      feed.title = rss.at('//item/title').text
      feed.date = rss.at('//item/pubDate').text
      feed.enclosure = rss.at('//item/enclosure').attr('url')
      feed
    end
  end
  class Channels
    cattr_accessor :feeds
    urls = [
      'http://leecamp.net/feed/',
      'http://therealnews.com/rss/therealnews.rss'
    ]
    feeds_a = []
    urls.each {|u| feeds_a.push(Feed.parse(u))}
    self.feeds = feeds_a
  end
end

