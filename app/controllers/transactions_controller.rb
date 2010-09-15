class NoAmountSet < StandardError; end
class NoToSet < StandardError; end

class TransactionsController < ApplicationController
  layout :flexible_layout
     #skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_actor_name]
  before_filter :set_title

  def new
    @transaction = current_user.transactions.new
    @transaction.steps.build
  end

  def create
    transaction = params[:transaction]
    to = current_user.associates.find_or_create_by_name(transaction[:to])

    raise NoToSet unless to

    transaction.merge!({:to => to})
    amount = (transaction[:amount].to_f / transaction[:steps_attributes].length.to_f)

    raise NoAmountSet unless amount

    transaction[:steps_attributes].try(:each) do |id, step|
      step_from = current_user.associates.find_or_create_by_name(step[:from])
      step.merge!({:from => step_from, :to => to, :amount => amount})
    end

    current_user.transactions.create!(transaction)
    redirect_to transactions_path

  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Owie! That wasn't your account!"
    redirect_to transactions_path

  rescue NoAmountSet, NoPayerSet
      flash[:error] = "You didn't pass the validation on this form"
      @transaction ||= current_user.transactions.new
    render :action => "new"
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

    if new_transaction.try(:save)
      @transactions = @transaction = current_user.transactions
      respond_to do |format|
        format.js do
          render :update do |page|
            page.insert_html :bottom, 'table_of_transactions', :partial => "transactions/transaction", :locals => {:transaction => new_transaction}
          end
        end
      end
    else
      render :nothing => true, :status => :not_acceptable
    end
  end

  def show
    @transaction = current_user.transactions.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to transactions_path
  end
  
  def show_anonymous
    @step = Step.find_by_unique_magic_hash(params[:unique_magic_hash])  
    render :layout => false
  rescue ActiveRecord::RecordNotFound
    redirect_to transactions_path
  end
  
  #emails reminders to the identities in the steps
  def mail
    @transaction = Transaction.find(params[:id])
    
    @transaction.steps.each do |step|
      StepMailer.deliver_uome_email(step)
    end
  end
  
  def index
    @transactions = current_user.transactions
  end

  def edit
    @transaction = current_user.transactions.find(params[:id])
  end

  def update
    debugger
    i=0
    i+=1
    #account = current_user.accounts.find(params[:transaction][:account_id])
    #recipient = current_user.friends.find_or_create_by_name(params[:recipient])
    #friends = current_user.friends

    #@transaction = account.transactions.find(params[:id])
    #if @transaction.update_attributes(params[:transaction].merge(:recipient_id => recipient.id))
      #line_items = params['line_items']
      #line_items.each do |key, updated_info|
        #friend = friends.find_or_create_by_name(updated_info["friend"]) || friends.create!(:name => updated_info["friend"])
        #line_item = @transaction.line_items.find(key)
        ##If we are changing who owes the debt, we need to balance the accounts. Easiest way is to delete the old
        ##line item and create a new one for the new friend
        #if friend != line_item.friend
          #line_item.delete
          #@transaction.line_items << LineItem.create!(line_item.except("friend").merge(:friend_id => friend.id))
        #else
          #line_item.update_attributes(updated_info.except("friend").merge(:friend_id => friend.id))
        #end

      #end

      #new_line_items = params['new_line_items']
      #if new_line_items
        #new_line_items.each do |key, line_item|
          #next unless line_item["friend"].present? && line_item["amount"].present?
          #friend = friends.find_by_name(line_item["friend"]) || friends.create!(:name => line_item["friend"])
          #@transaction.line_items << LineItem.create!(line_item.except("friend").merge(:friend_id => friend.id))
        #end
      #end

    #else
      #render :action => "edit"
    #end
    redirect_to :action => :index
  end


  #def auto_complete_for_actor_name
    #actor = params[:term]
    #@actors = current_user.actors.find(:all, :conditions => "name like '%" + actor + "%'")
    #if @actors.present?
      #render :text => @actors.map(&:name).to_json
    #else
      #render :text => "".to_json
    #end
  #end

  def auto_complete_for_friend_name
    friend = params[:term]
    #@associates = current_user.associates.find(:all, :conditions => "name like '%" + friend + "%'")

    @associates = current_user.associates.find_by_name_like(friend)
    if @associates.present?
      render :json => @associates.map(&:name), :status => :ok
    else
      render :json => params[:term], :status => :ok
    end
  end

  def delete
    debugger
    i=0
    i+=1
    transaction = current_user.transactions.find(params[:id])
    transaction.destroy
    redirect_to transactions_path()
  rescue ActiveRecord::RecordNotFound
    redirect_to transactions_path()
  end

  def change_state
    dealing =   Dealing.find(params[:id]) if params[:id]
    #dealing ||= Dealing.find(params[:unique_magic_hash])
    event   = params[:event]

    raise 'Invalid Event' unless dealing.user_can_trigger_event(event, params[:unique_magic_hash])

    dealing.send("#{event}!")

    transaction, dealings =
      if dealing.is_a?(Transaction)
        [ dealing, dealing.steps ]
      else
        [ dealing.transaction, [dealing] ]
      end

    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "state_link_#{transaction.id}", :partial => "transactions/state", :locals => {:transaction => transaction}

          dealings.each do |dealing|
            page.replace_html "step_state_link_#{dealing.id}", :partial => "transactions/state", :locals => {:transaction => dealing}
          end
        end
      end
    end
  end

private

  def set_title
    @title = "Transaction"
  end

  def flexible_layout
    if %w(new edit).include?(action_name)
      "ac_pages"
    elsif action_name == "understand"
      ""
    else
      "default"
    end
  end
end
