class EventsController < ApplicationController
  layout "leftnav"
     #skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_actor_name]

  def new
    account = current_user.accounts.find(params[:account_id])
    @event = Event.new(:account_id => account.id)
  end

  def create
    account = current_user.accounts.find(params[:event][:account_id])
    actor = current_user.actors.find_or_create_by_name(params[:actor])
    friends = current_user.friends

    @event = account.events.new(params["event"].merge(:actor_id => actor.id))
    if @event && @event.valid? && @event.save! && @event.errors.empty?
      line_item_params = params['line_items']

      #Since the first line item is automatically created, but invisible, make sure it's populated.
      if line_item_params && params['line_items']['0']["friend"].present?
        line_item_params.each do |key, line_item|
          friend = friends.find_by_name(line_item["friend"]) || friends.create!(:name => line_item["friend"])
          @event.line_items << LineItem.create!(line_item.except("friend").merge(:friend_id => friend.id))
        end
      end

      redirect_to :action => :index
    else
      flash[:error] = "You didn't pass the validation on this form"
      @last_entered_name = params["actor"]["name"]
      render :action => "new"
    end

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

  def auto_complete_for_friend_name
    friend = params[:term]
    @friends = current_user.friends.find(:all, :conditions => "name like '%" + friend + "%'")
    if @friends.present?
      render :text => @friends.map{|x| x.name}.to_json
    else
      render :text => "".to_json
    end
  end
  
end
