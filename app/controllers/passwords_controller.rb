class PasswordsController < ApplicationController
  layout 'signup'
  skip_before_filter :login_required
  #before_filter :not_logged_in_required, :only => [:new, :create]

  # Enter email address to recover password
  def new
  end

  # Forgot password action
  def create
    return unless request.post?
    if @account = Account.find_for_forget(params[:email])
      @account.forgot_password
      @account.save
      flash[:notice] = "A password reset link has been sent to your email address."
      redirect_to login_path
    else
      flash[:notice] = "Could not find a account with that email address."
      render :action => 'new'
    end
  end

  # Action triggered by clicking on the /reset_password/:id link recieved via email
  # Makes sure the id code is included
  # Checks that the id code matches a account in the database
  # Then if everything checks out, shows the password reset fields
  def edit
    if params[:id].nil?
      render :action => 'new'
      return
    end
    @account = Account.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @account.nil?
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:notice] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)"
    #redirect_back_or_default('/')
    redirect_to new_account_path
  end

  # Reset password action /reset_password/:id
  # Checks once again that an id is included and makes sure that the password field isn't blank
  def update
    if params[:id].nil?
      render :action => 'new'
      return
    end
    if params[:password].blank?
      flash[:notice] = "Password field cannot be blank."
      render :action => 'edit', :id => params[:id]
      return
    end
    @account = Account.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @account.nil?
    return if @account unless params[:password]
    if (params[:password] == params[:password_confirmation])
      #Uncomment and comment lines with @account to have the account logged in after reset - not recommended
      #self.current_account = @account #for the next two lines to work
      #current_account.password_confirmation = params[:password_confirmation]
      #current_account.password = params[:password]
      #@account.reset_password
      #flash[:notice] = current_account.save ? "Password reset" : "Password not reset"
      @account.password_confirmation = params[:password_confirmation]
      @account.password = params[:password]
      @account.reset_password
      flash[:notice] = @account.save ? "Password reset." : "Password not reset."
    else
      flash[:notice] = "Password mismatch."
      render :action => 'edit', :id => params[:id]
      return
    end
    redirect_to login_path
  rescue
    logger.error "Invalid Reset Code entered"
    flash[:notice] = "Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)"
    redirect_to new_account_path
  end

end

