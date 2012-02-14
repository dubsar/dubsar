module Admin
  class BaseController < ApplicationController
    before_filter :require_login
  end
end

