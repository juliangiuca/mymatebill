module TransactionsHelper
  def ltt(text)
    return true unless text
    link_to(text, transaction_path(:id => @transaction.id))
  end
end
