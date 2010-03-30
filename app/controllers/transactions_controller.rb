class NoAmountSet < StandardError; end
class NoPayeredSet < StandardError; end

class TransactionsController < ApplicationController
  layout "leftnav"
     #skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_actor_name]

  def new
    account = current_user.accounts.find(params[:account_id])
    @transaction = Transaction.new(:account_id => account.id)
  end

  def create
    account = current_user.accounts.find(params[:transaction][:account_id])
    recipient = current_user.friends.find_or_create_by_name(params[:recipient])
    friends = current_user.friends
    line_item_params = params['line_items']

    raise NoPayeredSet, "You need to specify the payer" unless line_item_params

    key, line_item = line_item_params.shift
    @transaction = account.transactions.new(params["transaction"].merge(:recipient_id => recipient.id))
    friend = friends.find_or_create_by_name(:name => line_item["friend"])
    @transaction.line_items.build(line_item.except("friend").merge({:friend_id => friend.id}))

    raise NoAmountSet, "You need an amount set" if @transaction.amount.nil?
    if @transaction && @transaction.valid? && @transaction.errors.empty?

      #Since the first line item is automatically created, but invisible, make sure it's populated with a 'real' friend entry.
      if line_item_params
        line_item_params.each do |key, line_item|
          next unless line_item["friend"].present? && line_item["amount"].present?
          friend = friends.find_or_create_by_name(:name => line_item["friend"])
          @transaction.line_items.build(line_item.except("friend").merge({:friend_id => friend.id}))
        end
      end

      @transaction.save!

      redirect_to accounts_path
    else
      @last_entered_name = params["recipient"]["name"]
      render :action => "new"
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Owie! That wasn't your account!"
    redirect_to accounts_path

  rescue NoAmountSet, NoPayeredSet
      flash[:error] = "You didn't pass the validation on this form"
      @transaction ||= Transaction.new(:account_id => account.id)
      @last_entered_name = params["recipient"]["name"] if params && params["recipient"]["name"]
    render :action => "new"
  end

  def text_add
    account = current_user.accounts.find(params[:account_id])
    @transaction = Transaction.new(:account_id => account.id)
  end

  def understand
    understood_text = Understand.transaction(current_user, params['input'])
    render :text => understood_text.to_json
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def index
    @accounts = current_user.accounts
    @transactions = current_user.accounts.map(&:transactions).flatten(1)
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    account = current_user.accounts.find(params[:transaction][:account_id])
    recipient = current_user.friends.find_or_create_by_name(params[:recipient])
    friends = current_user.friends

    @transaction = account.transactions.find(params[:id])
    if @transaction.update_attributes(params[:transaction].merge(:recipient_id => recipient.id))
      line_items = params['line_items']
      line_items.each do |key, updated_info|
        friend = friends.find_by_name(updated_info["friend"]) || friends.create!(:name => updated_info["friend"])
        line_item = @transaction.line_items.find(key)
        #If we are changing who owes the debt, we need to balance the accounts. Easiest way is to delete the old
        #line item and create a new one for the new friend
        if friend != line_item.friend
          line_item.delete
          @transaction.line_items << LineItem.create!(line_item.except("friend").merge(:friend_id => friend.id))
        else
          line_item.update_attributes(updated_info.except("friend").merge(:friend_id => friend.id))
        end

      end

      new_line_items = params['new_line_items']
      if new_line_items
        new_line_items.each do |key, line_item|
          next unless line_item["friend"].present? && line_item["amount"].present?
          friend = friends.find_by_name(line_item["friend"]) || friends.create!(:name => line_item["friend"])
          @transaction.line_items << LineItem.create!(line_item.except("friend").merge(:friend_id => friend.id))
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
