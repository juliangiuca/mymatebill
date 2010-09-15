class StepMailer < ActionMailer::Base
  #you owe me
  def uome_email(step)
    recipients    step.from.email
    from          'MyMateBill <no_reply@mymatebill.com>'
    subject       "'you owe me #{step.amount}, pay up bitch!' #{step.to.name} "
    sent_on       Time.now
    body          :step => step
  end 
  
  #I owe you
  def iou_email(transaction)   
    recipients    transaction.to.email
    from          "MyMateBill <no_reply@mymatebill.com>"
    subject       "I owe you #{transaction.amount}"
    sent_on       Time.now
    body          :transaction => transaction
  end
end
