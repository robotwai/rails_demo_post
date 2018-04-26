class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1'? remember(user): forget(user)
        redirect_back_or user
      else
        message = "Account not activated."
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
  		
	else
		flash[:danger] = 'Invalid email/password combination'
		render 'new'
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end

  #TODO 
  def applogin
  	p params
  	@user = User.find_by(email: params["email"].downcase)

  	if @user && @user.authenticate(params["password"])
  		remember(@user)
  		respond_to do |format|
	      format.json {render json: {'status'=>"0",'data'=> {"name": @user.name,"email": @user.email,"token": @user.remember_token}.to_json} }
	    end
	else
		respond_to do |format|
			format.json render json: {'status'=>"1",'data'=> "failed"}
		end	
  	end
  end
end
