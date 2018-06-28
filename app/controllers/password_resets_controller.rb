class PasswordResetsController < ApplicationController

  before_action :get_user,only: [:edit,:update]
  before_action :valid_user, only: [:edit,:update]
  before_action :check_expiration, only: [:edit,:update]
  def new
  end

  def edit
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email])
  	if @user
  		if @user.activated?
  			@user.create_password_reset_digest
        @user.send_reset_email
	  		flash[:info] = "Please check your email to activate your account"
	  		redirect_to root_url
	  	else
	  		message = "Account not activated."
	        message += "Check your email for the activation link"
	        flash[:warning] = message
	        redirect_to root_url
	  	end
  	else
  		flash[:danger] = 'Invalid email combination'
		  render 'new'
  		
  	end
  	
  end

  def update
    
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def user_params
      params.require(:user).permit(:password,:password_confirmation)
    end

    def valid_user
      unless (@user &&@user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired"
        redirect_to new_password_reset_url
      end
    end
end
