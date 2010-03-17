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

      #Since the first line item is automatically created, but invisible, make sure it's populated with a 'real' friend entry.
      if line_item_params
        line_item_params.each do |key, line_item|
          next unless line_item["friend"].present? && line_item["amount"].present?
          friend = friends.find_by_name(line_item["friend"]) || friends.create!(:name => line_item["friend"])
          LineItem.create!(line_item.except("friend").merge({:friend_id => friend.id, :event_id => @event.id}))
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

  def edit
    @event = Event.find(params[:id])
  end

  def update
    account = current_user.accounts.find(params[:event][:account_id])
    actor = current_user.actors.find_or_create_by_name(params[:actor])
    friends = current_user.friends

    @event = account.events.find(params[:id])
    if @event.update_attributes(params[:event].merge(:actor_id => actor.id))
      line_items = params['line_items']
      line_items.each do |key, updated_info|
        friend = friends.find_by_name(updated_info["friend"]) || friends.create!(:name => updated_info["friend"])
        line_item = @event.line_items.find(key)
        #If we are changing who owes the debt, we need to balance the accounts. Easiest way is to delete the old
        #line item and create a new one for the new friend
        if friend != line_item.friend
          line_item.delete
          @event.line_items << LineItem.create!(line_item.except("friend").merge(:friend_id => friend.id))
        else
          line_item.update_attributes(updated_info.except("friend").merge(:friend_id => friend.id))
        end

      end

      new_line_items = params['new_line_items']
      if new_line_items
        new_line_items.each do |key, line_item|
          next unless line_item["friend"].present? && line_item["amount"].present?
          friend = friends.find_by_name(line_item["friend"]) || friends.create!(:name => line_item["friend"])
          @event.line_items << LineItem.create!(line_item.except("friend").merge(:friend_id => friend.id))
        end
      end

    else
      render :action => "edit"
    end
    redirect_to :action => :index
  end

  def auto_complete_for_actor_name
    actor = params[:term]
    @actors = current_user.actors.find(:all, :conditions => "name like '%" + actor + "%'")
    if @actors.present?
      render :text => @actors.map(&:name).to_json
    else
      render :text => "".to_json
    end
  end

  def auto_complete_for_friend_name
    friend = params[:term]
    @friends = current_user.friends.find(:all, :conditions => "name like '%" + friend + "%'")
    if @friends.present?
      render :text => @friends.map(&:name).to_json
    else
      render :text => "".to_json
    end
  end
  
end
