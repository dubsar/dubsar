module Admin
  class BaseController < HomeController
    before_filter :require_login
  end
end

