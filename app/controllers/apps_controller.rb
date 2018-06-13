class AppsController < ApplicationController
	before_action :find_user, except: [:loggin,:register]

	def loggin
	  user = User.find_by(email: params["email"].downcase)
      ps = params["password"]
      if user && user.authenticate(ps)
	      if user.activated?
            remember(user)
            p user.icon
            render json: {'status'=>"0",'data'=> {
            	"name": user.name,
            	"email": user.email,
            	"token": user.remember_digest,
            	"icon": user.icon.url,
            	"id": user.id,
            	"sign_content": "生命像一场没有尽头的旅行",
            	"followed": user.following.count,
            	"follower": user.followers.count}.to_json} 
	      else
            render json: {'status'=>"1",'data'=> {
	        	'message': 'Check your email for the activation link'
	        	}.to_json}
	      end
  	  else
          render json: {'status'=>"1",'data'=> {
	        	'message': 'Invalid email/password combination'
	        	}.to_json}
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
        	@app_feed[:dotId] = x.dotId(@user.id)
        	@app_feed[:dots_num] = x.dots.count
        	@app_feed[:comment_num] = x.comments.count
        	a.push(@app_feed)
        end
        # render json: a
        render json: {'status'=>"0",'data'=> a}
	end

	def seedmicropost
		@micropost = @user.microposts.build(content: params[:content],picture: params[:picture] )
      	
      	if @micropost.save
			render json: {'status'=>"0",'data'=> {
	        	'message': 'success'
	        	}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
	        	'message': 'send faild'
	        	}.to_json}
		end
	end

	def register
		@user = User.new
        @user.name = params[:name]
	    @user.email = params[:email]
	    @user.password = params[:password]
	    @user.password_confirmation = params[:password_confirmation]
	    @user.icon = params[:icon]
	  	if @user.save
	        render json: {'status'=>"0",'data'=> {
	        	'message': 'success'
	        	}.to_json}
	  	else
	       
	        render json: {'status'=>"1",'data'=> {
	        	'message': 'Invalid email/password combination'
	        	}.to_json}
	  	end
	end

	def commit
		@micropost = Micropost.find(params[:id])
		@comment = @micropost.build(body: params[:content],commenter: ' ')
		if @comment.save
			render json: {'status'=>"0",'data'=> {
	        	'message': 'success'
	        	}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
	        	'message': 'send faild'
	        	}.to_json}
		end
	end

	def dot
		@dot = Dot.new(micropost_id: params[:micropost_id],user_id: @user.id)
		@micropost = Micropost.find(params[:micropost_id])
		if @dot.save
			render json: {'status'=>"0",'data'=> {
            	"id": @micropost.id,
            	"content": @micropost.content,
            	"user_id": @micropost.user_id,
            	"picture": @micropost.picture.url,
            	"icon": @micropost.user.icon.url,
            	"user_name": @micropost.user.name,
            	"created_at": @micropost.created_at,
            	"dotId": @micropost.dotId(@user.id),
            	"dots_num": @micropost.dots.count,
            	"comment_num": @micropost.comments.count,}.to_json} 
        else
        	render json: {'status'=>"1",'data'=> {
	        	'message': 'error'
	        	}.to_json}
		end
	end

	def getMicropost
		@micropost = Micropost.find(params[:id])
		render json: {'status'=>"0",'data'=> {
            	"id": @micropost.id,
            	"content": @micropost.content,
            	"user_id": @micropost.user_id,
            	"icon": @micropost.user.icon.url,
            	"user_name": @micropost.user.name,
            	"created_at": @micropost.created_at,
            	"dotId": @micropost.dotId(@user.id),
            	"dots_num": @micropost.dots.count,
            	"comment_num": @micropost.comments.count,}.to_json} 

	end


	private
	
	def find_user
		@user = User.find_by(remember_digest: params[:token])
		if @user.nil?
			p "aaaa"
			# json_str= {'status'=>"2",'data'=> "token is empty"}
			render json: {'status'=>"2",'data'=> {
	        	'message': 'token is empty'
	        	}.to_json}
			# render :json=>{'status'=>"2",'data'=> "token is empty"}, status=>"301"
		end
	end
end
