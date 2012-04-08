module Names
  class NamesController < ApplicationController
    layout 'home'
    respond_to :html
  end
  def show
    puts params
  end
end
