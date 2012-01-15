require 'rss'

class FeedsController < ApplicationController

# GET /subjects
  # GET /subjects.json
  def index
    @feeds = Rss::Channels.feeds

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subjects }
    end
  end
end

