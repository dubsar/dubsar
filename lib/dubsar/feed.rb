# A wrapper for Feedzirra:Feed
module Feed
  class Entry
    @entry
    def initialize(_entry)
      @entry = _entry
    end
    def method_missing(method_sym, *arguments, &block)
      if @entry.respond_to? method_sym
        @entry.send method_sym
      else
        super
      end
    end
    def respond_to?(method_sym, include_private = false)
      @entry.repond_to? method_sym
    end
  end
  class Channel
    @feed
    def initialize(_feed)
      @feed = _feed
    end
    def entries
      unless @entries
        @entries = []
        @feed.entries.each {|entry| @entries << Entry.new(entry)}
      end
      @entries
    end
    def method_missing(method_sym, *arguments, &block)
      if @feed.respond_to? method_sym
        @feed.send method_sym
      else
        super
      end
    end
    def respond_to?(method_sym, include_private = false)
      @feed.repond_to? method_sym
    end
  end
  class Builder
    class << self
      def load(thing)
        thing_type = thing.class.name.split("::").first
        raise ArgumentError, "String or Feedzirra::Feed" unless ["String", "Feedzirra"].include?(thing_type)
        case thing_type
        when "Feedzirra"
          return Channel.new(thing)
        else
          feed = Feedzirra::Feed.fetch_and_parse(thing)
          raise ArgumentError, "Invalid uri" if feed == 0;
          return Channel.new(feed)
        end
      end
    end
  end
end

