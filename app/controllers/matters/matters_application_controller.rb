module Matters
  class MattersApplicationController < ApplicationController
    before_filter :require_login
  end
end
