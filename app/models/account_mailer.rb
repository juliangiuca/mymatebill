class AccountMailer < ActionMailer::Base
  def signup_notification(account)
    setup_email(account)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{@@site[:url]}/activate/#{account.activation_code}"
  end
  
  def activation(account)
    setup_email(account)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{@@site[:url]}/"
  end
  
  def forgot_password(account)
    setup_email(account)
    @subject    += 'You have requested to change your password'
    @body[:url]  = "http://#{@@site[:url]}/reset_password/#{account.password_reset_code}" 
  end

  def reset_password(account)
    setup_email(account)
    @subject    += 'Your password has been reset.'
  end
  
  protected
    def setup_email(account)
      @recipients  = "#{account.email}"
      @from        = "#{@@site[:name]} Admin"
      @subject     = "#{@@site[:name]} "
      @sent_on     = Time.now
      @body[:account] = account
    end
end
