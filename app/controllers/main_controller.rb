class MainController < ApplicationController
  layout "signup"
  skip_before_filter :login_required, :only => [:success]

  def success
    @title = "Success!"
  end
end
