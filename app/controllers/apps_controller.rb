class AppsController < ApplicationController
	before_action :find_user, except: :loggin
	def loggin
	  user = User.find_by(email: params["email"].downcase)
      ps = params["password"]

      if user && user.authenticate(ps)
	      if user.activated?

	        
            remember(user)
            p user.icon
            render json: {'status'=>"0",'data'=> {"name": user.name,"email": user.email,"token": user.remember_token,"icon": user.icon.url,"id": user.id}.to_json} 
	          
	      else
	        
	          
            render json: {'status'=>"1",'data'=> "Check your email for the activation link"}
	          
	        
	        
	      end
	  		
  	  else
     
        
          render json: {'status'=>"1",'data'=> "Invalid email/password combination"}
        
      
	  end

    end

	def show
		render json: User.find(@id)
	end


	private

	
	def find_user
		@id = User.find_by(remember_digest: params[:token]).id
	end
end
