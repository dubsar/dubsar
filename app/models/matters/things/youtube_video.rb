module Matters
  module Things
    class YoutubeVideo < Video
      attr_writer :autoplay
      def content
        title << " " << description
      end
      class << self
        # @return [Video]
        def random
          order("RANDOM()").first
        end
      end
      def src()
        self.youtube_id ||= random.youtube_id
        url = "http://www.youtube.com/embed/#{self.youtube_id}"
        query_string = "?fs=1&wmode=opaque"
        query_string << "&autoplay=1" if self.autoplay
        url << query_string
      end
      def describe
        title
      end
      def autoplay
        true unless (@autoplay == false)
      end
    end
  end
end
