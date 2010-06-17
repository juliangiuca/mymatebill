class AccountObserver < ActiveRecord::Observer
  def after_create(account)
    AccountMailer.deliver_signup_notification(account)
  end

  def after_save(account) 
    #AccountMailer.deliver_activation(account) if account.active?
    AccountMailer.deliver_forgot_password(account) if account.recently_forgot_password?
    AccountMailer.deliver_reset_password(account) if account.recently_reset_password?
  end

end
