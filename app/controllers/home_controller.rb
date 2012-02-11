class HomeController < ApplicationController
  def index
    @video = YoutubeVideo.random
    @video.autoplay = false
  end
  def search
  end
  def find
    @search = Search.query(params['q'])
    render :layout => "find"
  end
  def view
    item = Item.new(params);
    if item.clazz < Video
      @video = item.clazz.find item.id
      render :play
    end
  end
  def play
  end
  def read
  end
  def cloud
    render :json => Search.cloud
  end
  private
  class Item
    def initialize(_params)
      @params = _params
    end
    def clazz
      class_for(@params['item-class'])
    end
    def id
      @params['item-id'] || default_id
    end
    def class_for(_table_name)
      clazz = default_clazz
      begin
        clazz = _table_name.singularize.camelize.constantize
      rescue
      end
    end
    def default_clazz
      YoutubeVideo
    end
    def default_id
      YoutubeVideo.random.id
    end
  end
end

