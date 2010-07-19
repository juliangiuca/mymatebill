class NoAmountSet < StandardError; end
class NoPayerSet < StandardError; end

class TransactionsController < ApplicationController
  layout "default", :except => :understand
     #skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_actor_name]
  before_filter :set_title

  def set_title
    @title = "Transaction"
  end

  def new
    @transaction = current_user.transactions.new
    @transaction.steps.build
  end

  def create
    transaction = params[:transaction]
    to = current_user.associates.find_or_create_by_name(transaction[:to])
    from = current_user.associates.find_or_create_by_name(transaction[:from]) if transaction[:from]

    transaction.merge!({:to => to, :from => from})

    transaction[:steps_attributes].try(:each) do |id, step|
      step_from = current_user.associates.find_or_create_by_name(step[:from])
      step.merge!({:from => step_from, :to => to})
    end

    current_user.transactions.create!(transaction)
    redirect_to transactions_path
    #associates = current_user.associates
    #recipient = current_user.associates.find_by_name(params[:recipient]) || current_user.associates.create!(:name => params[:recipient])
    #line_item_params = params['line_items']

    #raise NoPayerSet, "You need to specify the payer" unless line_item_params

    #key, line_item = line_item_params.shift
    #@transaction = current_user.transactions.new(params["transaction"].merge(:recipient_id => recipient.id))
    #associates.find_by_name(:name => line_item["friend"]) || associates.create!(:name => line_item["friend"])
    #@transaction.line_items.build(line_item.except("friend").merge({:friend_id => friend.id}))

    #raise NoAmountSet, "You need an amount set" if @transaction.amount.nil?
    #if @transaction && @transaction.valid? && @transaction.errors.empty?

      ##Since the first line item is automatically created, but invisible, make sure it's populated with a 'real' friend entry.
      #if line_item_params
        #line_item_params.each do |key, line_item|
          #next unless line_item["friend"].present? && line_item["amount"].present?
          #associate = associates.find_by_name(:name => line_item["friend"]) || associates.create!(:name => line_item["friend"])
          #@transaction.line_items.build(line_item.except("friend").merge({:friend_id => friend.id}))
        #end
      #end

      #@transaction.save!

      #redirect_to transactions_path
    #else
      #@last_entered_name = params["recipient"]["name"]
      #render :action => "new"
    #end

  #rescue ActiveRecord::RecordNotFound
    #flash[:error] = "Owie! That wasn't your account!"
    #redirect_to transactions_path

  #rescue NoAmountSet, NoPayerSet
      #flash[:error] = "You didn't pass the validation on this form"
      #@transaction ||= current_user.transactions.new
      #@last_entered_name = params["recipient"]["name"] if params && params["recipient"]["name"]
    #render :action => "new"
  end

  def text_add
    @transaction = current_user.transactions.new
  end

  def understand
    understood_text = Understand.transaction(current_user, params['input'])

    new_transaction = current_user.transactions.new(
      { :to => current_user.associates.find_or_create_by_name(understood_text.in_credit || understood_text.unknown_in_credit),
        :from => current_user.associates.find_or_create_by_name(understood_text.in_debt || understood_text.unknown_in_debt),
        :amount => understood_text.amount.gsub(/[^0-9\.]+/,"").to_f,
        :description => understood_text.description
      }
    ) if understood_text.success?

    if new_transaction && new_transaction.save
      @transactions = @transaction = current_user.transactions
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace 'transaction_list_container', :partial => "transactions/transaction_table", :object => @transactions
          end
        end
      end
    else
      render :nothing => true, :status => :not_acceptable
    end
  end

  def show
    @transaction = current_user.transactions.find(params[:id])
  end

  def index
    @transactions = current_user.transactions
  end

  def edit
    @transaction = current_user.transactions.find(params[:id])
  end

  def update
    account = current_user.accounts.find(params[:transaction][:account_id])
    recipient = current_user.friends.find_or_create_by_name(params[:recipient])
    friends = current_user.friends

    @transaction = account.transactions.find(params[:id])
    if @transaction.update_attributes(params[:transaction].merge(:recipient_id => recipient.id))
      line_items = params['line_items']
      line_items.each do |key, updated_info|
        friend = friends.find_or_create_by_name(updated_info["friend"]) || friends.create!(:name => updated_info["friend"])
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
    @associates = current_user.associates.find(:all, :conditions => "name like '%" + friend + "%'")
    if @associates.present?
      render :json => @associates.map(&:name)
    else
      render :json => ""
    end
  end
end
