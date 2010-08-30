class MainController < ApplicationController
  layout "signup"
  skip_before_filter :login_required#, :only => [:success, :error]

  def success
    @title = "Success!"
  end

  def error
    raise "You fail! And you're ugly too!"
  end
end
