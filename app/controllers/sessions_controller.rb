class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:session].nil?
      user = User.find_by(email: params["email"].downcase)
      ps = params["password"]
    else
      user = User.find_by(email: params[:session][:email].downcase)
      ps = params[:session][:password]
    end
  	# user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(ps)
      if user.activated?

        respond_to do |format|
          format.html {
            log_in user
            params[:session][:remember_me] == '1'? remember(user): forget(user)
            redirect_back_or user
          }
          format.json {
            remember(user)
            p user.icon
            render json: {'status'=>"0",'data'=> {"name": user.name,"email": user.email,"token": user.remember_token,"icon": user.icon.url,"id": user.id}.to_json} 
          }
        end
        
      else
        respond_to do |format|
          format.html {
            message = "Account not activated."
            message += "Check your email for the activation link"
            flash[:warning] = message
            redirect_to root_url
          }
          format.json {
            render json: {'status'=>"1",'data'=> "Check your email for the activation link"}
          }
        end
        
      end
  		
  	else
      respond_to do |format|
            format.html {
              flash[:danger] = 'Invalid email/password combination'
              render 'new'
            }
            format.json {
              render json: {'status'=>"1",'data'=> "Invalid email/password combination"}
            }
      end
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end

end
