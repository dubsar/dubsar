module Names
  class NamesApplicationController < ApplicationController
    before_filter :require_login
  end
end
