class AccountsController < ApplicationController

  layout "leftnav"

  def index
    @accounts = current_user.accounts
    redirect_to events_path if @accounts.length == 1 && !params['force']
  end

  def new
    @account = current_user.accounts.new
  end

  def create
    @account = Account.create!(params["account"].merge(:user_id => current_user.id))
    render :action => :show
  end

  def show
    @account = Account.find(params[:id])
  end
end
