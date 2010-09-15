module TransactionsHelper
  def ltt(text)
    return true unless text
    link_to(text, transaction_path(:id => @transaction.id))
  end

  def id
    "tr_trans_#{@transaction.id}"
  end

  def created_at
    date_style(@transaction.created_at)
  end

  def full_transaction_title
    from = @transaction.steps.map{|x| x.from.name}.join(", ")
    to   = @transaction.to.name

    "#{from} -&gt; #{to}"
  end

  def short_transaction_title
    url          = friend_path(:id => @transaction.to)
    from         = @transaction.from.try(:name) || @transaction.steps.first.from.name
    to           = @transaction.to.name
    count_from   =
      if (count = @transaction.steps.length - 1) > 0
        "(+#{count})" 
      else
        ''
      end

    link_to(from, url) + count_from + " -> " + link_to(to, url)
  end

  def description
    @transaction.description || '-'
  end

  def currency
    number_to_currency @transaction.amount
  end

  def due
    if @transaction.due
      I18n.l(@transaction.due.to_date) 
    else
      '-'
    end
  end

  def confirm_message
    message = "Are you sure? This will affect all sub transactions for this transaction"

    if @transaction.respond_to?(:steps) \
    and @transaction.steps.length > 1
      message
    else
      false
    end
  end
end
