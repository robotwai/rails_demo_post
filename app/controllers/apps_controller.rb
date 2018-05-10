class AppsController < ApplicationController
	before_action :find_user, except: :loggin
	def loggin
	  user = User.find_by(email: params["email"].downcase)
      ps = params["password"]
      if user && user.authenticate(ps)
	      if user.activated?
            remember(user)
            p user.icon
            render json: {'status'=>"0",'data'=> {"name": user.name,"email": user.email,"token": user.remember_digest,"icon": user.icon.url,"id": user.id}.to_json} 
	      else
            render json: {'status'=>"1",'data'=> "Check your email for the activation link"}
	      end
  	  else
          render json: {'status'=>"1",'data'=> "Invalid email/password combination"}
	  end

    end


	def feed
		@feed_items = @user.feed.paginate(page: params[:page])
        a = Array.new
        @feed_items.each do |x|
        	@app_feed = {}
        	@app_feed[:id] = x[:id]
        	@app_feed[:content] = x[:content]
        	
        	@app_feed[:picture] = x.picture.url
        	@app_feed[:user_id] = x[:user_id]
        	@app_feed[:user_name] = User.find(x[:user_id]).name
        	@app_feed[:icon] = User.find(x[:user_id]).icon.url
        	@app_feed[:created_at] = x[:created_at]
        	a.push(@app_feed)
        end
        render json: a
	end


	private

	
	def find_user
		@user = User.find_by(remember_digest: params[:token])
	end
end
