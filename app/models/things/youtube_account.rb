class YoutubeAccount < Account
  include LazyMethods
  define_lazy_class_methods :load_feeds
  class << self
    def random
      order("RANDOM()").first
    end
    def load_feeds
      users = pluck(:user_name)
      users.each do |user|
        url = uploads_feed_url(user)
        channel = Feed::Builder.load(url)
        channel.entries.each do |entry|
          youtube_id = entry.id.split("/").last
          begin
            YoutubeVideo.where(youtube_id: youtube_id).first_or_create(
              youtube_user_name: user,
              title: entry.title,
              description: entry.content,
              published: entry.published,
              updated: entry.updated
            )
          rescue Exception => e
            puts e.message
          end
        end
      end
    end
    def uploads_feed_url(_user_name, _start=1, _offset=50)
      "http://gdata.youtube.com/feeds/api/users/#{_user_name}/uploads?orderby=updated&start-index=#{_start}&offset=#{_offset}"
    end
  end
end
