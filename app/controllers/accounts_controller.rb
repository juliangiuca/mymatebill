class AccountsController < ApplicationController

  layout "basic"

  def index
    @accounts = current_user.accounts
  end

  def new
    @account = current_user.accounts.new
  end

  def create
    debugger
    i=0
    i+=1
  end
end
