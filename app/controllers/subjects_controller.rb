class SubjectsController < ApplicationController
  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.grouped

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subjects }
    end
  end
end

