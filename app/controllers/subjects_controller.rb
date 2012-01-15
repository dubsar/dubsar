require 'feed'

class SubjectsController < ApplicationController

# GET /subjects
  # GET /subjects.json
  def index
    feed = Feed.new
    @subjects = Subject.grouped

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subjects }
    end
  end
end

