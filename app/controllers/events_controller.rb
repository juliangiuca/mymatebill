class EventsController < ApplicationController
  layout "basic"
     #skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_actor_name]

  def new
    account = current_user.accounts.find(params[:account_id])
    @event = account.events.new
  end

  def create
    account = current_user.accounts.find(params[:event][:account_id])
    actor = current_user.actors.find_or_create_by_name(params[:actor])
    @event = account.events.create!(params["event"].merge(:actor_id => actor.id))
    #redirect_to :action => :show, :id => @event.id
    redirect_to :action => :index

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Owie! That wasn't your account!"
    redirect_to accounts_path
  end

  def show
    @event = Event.find(params[:id])
  end

  def index
    #@events = current_user.events
    @accounts = current_user.accounts
  end

  def auto_complete_for_actor_name
    actor = params[:term]
    @actors = current_user.actors.find(:all, :conditions => "name like '%" + actor + "%'")
    if @actors.present?
      render :text => @actors.map{|x| x.name}.to_json
    else
      render :text => "".to_json
    end

  end
end
