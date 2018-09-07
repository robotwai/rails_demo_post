class AppsController < ApplicationController
	before_action :find_user, except: [:loggin,:register,:getCommit,:getFindMicroposts]

	def loggin
	  user = User.find_by(email: params["email"].downcase)
      ps = params["password"]
      if user && user.authenticate(ps)
	      
            remember(user)
            
            render json: {'status'=>"0",'data'=> {
            	"name": user.name,
            	"email": user.email,
            	"token": user.remember_digest,
            	"icon": user.icon.url,
            	"id": user.id,
            	"sign_content": user.sign_content,
							"sex": user.sex,
            	"followed": user.following.count,
            	"follower": user.followers.count}.to_json} 
	     
  	  else
          render json: {'status'=>"1",'data'=> {
	        	'message': '账号密码错误'
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
        	@b= ''
        	x.picture.each do |pic|
        		@b = @b+pic.url+','
        	end

        	@app_feed[:picture] = @b
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
		picNum = params[:picNum].to_i
		p picNum
		if picNum==0

			@micropost = @user.microposts.build(content: params[:content] )
		else
			pic = Array.new
			for i in 0..picNum
				name = 'picture'+i.to_s
				pic.push(params[name])
			end
			@micropost = @user.microposts.build(content: params[:content] ,picture: pic)
		end

      	
      	if @micropost.save
			render json: {'status'=>"0",'data'=> {
	        	'message': 'success'
	        	}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
	        	'message': '发送失败'
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
	        	'message': '账号或密码无效'
	        	}.to_json}
	  	end
	end


	def dot
		@dot = Dot.new(micropost_id: params[:micropost_id],user_id: @user.id)
		@micropost = Micropost.find(params[:micropost_id])
		@b= ''
    	@micropost.picture.each do |pic|
    		@b = @b+pic.url+','
    	end
		if @dot.save
			render json: {'status'=>"0",'data'=> {
            	"id": @micropost.id,
            	"content": @micropost.content,
            	"user_id": @micropost.user_id,
            
            	"picture": @b,
            	"icon": @micropost.user.icon.url,
            	"user_name": @micropost.user.name,
            	"created_at": @micropost.created_at,
            	"dotId": @micropost.dotId(@user.id),
            	"dots_num": @micropost.dots.count,
            	"comment_num": @micropost.comments.count,}.to_json} 
        else
        	render json: {'status'=>"1",'data'=> {
	        	'message': '请检查网络'
	        	}.to_json}
		end
	end

	def dotDestroy
		@dot = Dot.find(params[:micropost_id])
		@micropost = Micropost.find(@dot.micropost_id)
		@b= ''
		@micropost.picture.each do |pic|
    		@b = @b+pic.url+','
    	end
		if @dot.destroy
			render json: {'status'=>"0",'data'=> {
            	"id": @micropost.id,
            	"content": @micropost.content,
            	"user_id": @micropost.user_id,
            	"picture": @b,
            	"dotId": 0,
            	"icon": @micropost.user.icon.url,
            	"user_name": @micropost.user.name,
            	"created_at": @micropost.created_at,
            	"dots_num": @micropost.dots.count,
            	"comment_num": @micropost.comments.count,}.to_json}
        else
        	render json: {'status'=>"1",'data'=> {
	        	'message': '请检查网络'
	        	}.to_json}
	    end
	end

	def getMicropost
		@micropost = Micropost.find(params[:id])
		@b= ''
		@micropost.picture.each do |pic|
    		@b = @b+pic.url+','
    	end
		if @micropost!=nil
			render json: {'status'=>"0",'data'=> {
            	"id": @micropost.id,
            	"content": @micropost.content,
            	"picture": @b,
            	"user_id": @micropost.user_id,
            	"icon": @micropost.user.icon.url,
            	"user_name": @micropost.user.name,
            	"created_at": @micropost.created_at,
            	"dotId": @micropost.dotId(@user.id),
            	"dots_num": @micropost.dots.count,
            	"comment_num": @micropost.comments.count,}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
	        	'message': '请检查网络'
	        	}.to_json}
		end
	end

	def getCommit
		
		@commits = Micropost.find(params[:id]).comments.paginate(page: params[:page])
        a = Array.new
        @commits.each do |x|
        	@app_feed = {}

        	@app_feed[:id] = x[:id]
        	@app_feed[:body] = x[:body]
        	
        	@app_feed[:micropost_id] = x.micropost_id
        	@app_feed[:created_at] = x.created_at
        	@b = User.find(x.user_id)
        	@app_feed[:user_id] = x.user_id
        	@app_feed[:user_name] = @b.name
        	@app_feed[:icon] = @b.icon.url
        	a.push(@app_feed)
        end
        # render json: a
        render json: {'status'=>"0",'data'=> a}
	end
	
	def getDots
		
		@dots = Micropost.find(params[:id]).dots.paginate(page: params[:page])
        a = Array.new
        @dots.each do |x|
        	@app_feed = {}

        	@app_feed[:id] = x[:id]
        	
        	@app_feed[:created_at] = x.created_at
        	@b = User.find(x.user_id)
        	@app_feed[:user_id] = x.user_id
        	@app_feed[:user_name] = @b.name
        	@app_feed[:icon] = @b.icon.url
        	a.push(@app_feed)
        end
        # render json: a
        render json: {'status'=>"0",'data'=> a}
	end

	def seedcommit


			@commit = Comment.new(micropost_id: params[:micropost_id],body: params[:comment],user_id: @user.id)

			

		if @commit.save
			render json: {'status'=>"0",'data'=> {
					'message': 'success'
			}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
					'message': '发送失败'
			}.to_json}
		end
	end

	def getUser
		user = User.find(params[:user_id])
		b= 0
		if(@user.following?(user))
			b = b+2
		end
		if(user.following?(@user))
			b = b+1
		end
		if user!=nil
			render json: {'status'=>"0",'data'=> {
            	"name": user.name,
            	"email": user.email,
            	"icon": user.icon.url,
            	"id": user.id,
            	"sign_content": user.sign_content,
							"sex": user.sex,
            	"followed": user.following.count,
            	"relation": b,
            	"micropost_num": user.microposts.size,
            	"follower": user.followers.count}.to_json} 
        else
            render json: {'status'=>"1",'data'=> {
					'message': '用户未找到'
			}.to_json}	
		end
	end

	def getUserMicroposts
		@feed_items =User.find(params[:user_id]).microposts.paginate(page: params[:page])
        a = Array.new
        @feed_items.each do |x|
        	@app_feed = {}
        	@app_feed[:id] = x[:id]
        	@app_feed[:content] = x[:content]
        	@b= ''
        	x.picture.each do |pic|
        		@b = @b+pic.url+','
        	end

        	@app_feed[:picture] = @b
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

	def getUserDotMicroposts
		@feed_items =User.find(params[:user_id]).dots.paginate(page: params[:page])
		a = Array.new
		@feed_items.each do |y|
			x = y.micropost
			@app_feed = {}
			@app_feed[:id] = x[:id]
			@app_feed[:content] = x[:content]
			@b= ''
			x.picture.each do |pic|
				@b = @b+pic.url+','
			end

			@app_feed[:picture] = @b
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

	def getFindMicroposts
		@feed_items =Micropost.paginate(page: params[:page])
		if params[:token].nil?
			a = Array.new
	        @feed_items.each do |x|
	        	@app_feed = {}
	        	@app_feed[:id] = x[:id]
	        	@app_feed[:content] = x[:content]
	        	@b= ''
	        	x.picture.each do |pic|
	        		@b = @b+pic.url+','
	        	end

	        	@app_feed[:picture] = @b
	        	@app_feed[:user_id] = x[:user_id]
	        	@app_feed[:user_name] = User.find(x[:user_id]).name
	        	@app_feed[:icon] = User.find(x[:user_id]).icon.url
	        	@app_feed[:created_at] = x[:created_at]

	        	@app_feed[:dotId] = 0
	        	@app_feed[:dots_num] = x.dots.count
	        	@app_feed[:comment_num] = x.comments.count
	        	a.push(@app_feed)
	        end
			# render json: a
			render json: {'status'=>"0",'data'=> a}
		else
			@user = User.find_by(remember_digest: params[:token])
			a = Array.new
	        @feed_items.each do |x|
	        	@app_feed = {}
	        	@app_feed[:id] = x[:id]
	        	@app_feed[:content] = x[:content]
	        	@b= ''
	        	x.picture.each do |pic|
	        		@b = @b+pic.url+','
	        	end

	        	@app_feed[:picture] = @b
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
		
	end

	def follow
		user = User.find(params[:id])
		if @user.follow(user)
			render json: {'status'=>"0",'data'=> {
					'message': 'success'
			}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
					'message': '关注失败'
			}.to_json}
		end
		
	end

	def unfollow
		user = User.find(params[:id])
		if @user.unfollow(user)
			render json: {'status'=>"0",'data'=> {
					'message': 'success'
			}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
					'message': '取消关注失败'
			}.to_json}
		end
		
	end

	def get_follower_users
		if params[:type]=='1'
			@users_items =User.find(params[:id]).following.paginate(page: params[:page])
		else
			@users_items =User.find(params[:id]).followers.paginate(page: params[:page])
		end
		
		a = Array.new
		@users_items.each do |x|
			@app_feed = {}
			@app_feed[:id] = x[:id]
			@app_feed[:sign_content] = x.sign_content
			@app_feed[:sex] = x.sex
			@app_feed[:name] = x[:name]
			@app_feed[:icon] = x.icon.url
			@app_feed[:created_at] = x[:created_at]
			b= 0
			if(@user.following?(x))
				b = b+2
			end
			if(x.following?(@user))
				b = b+1
			end
			@app_feed[:relation] = b
        	a.push(@app_feed)
		end
		# render json: a
		render json: {'status'=>"0",'data'=> a}
	end

	def user_update
		if params[:name]!=nil
			@user.name = params[:name]
		end
		if params[:sign_content]!=nil
			@user.sign_content = params[:sign_content]
		end
		if params[:sex]!=nil
			@user.sex = params[:sex]
		end
		if params[:icon]!=nil
			@user.icon = params[:icon]
		end
		p @user
		if @user.save
			render json: {'status'=>"0",'data'=> {
					"name": @user.name,
					"email": @user.email,
					"token": @user.remember_digest,
					"icon": @user.icon.url,
					"id": @user.id,
					"sign_content": @user.sign_content,
					"sex": @user.sex,
					"followed": @user.following.count,
					"follower": @user.followers.count}.to_json}
			p 'ok'
		else
			p 'error'
			render json: {'status'=>"1",'data'=> {
					'message': '提交失败'
			}.to_json}
		end
	end

	def micropost_destroy
		@micropost = Micropost.find(params[:id])
		if @micropost.destroy
			render json: {'status'=>"0",'data'=> {
					'message': 'success'
			}.to_json}
		else
			render json: {'status'=>"1",'data'=> {
					'message': '删除失败'
			}.to_json}
		end
	end

	def account_destroy
		if @user.authenticate(params[:password])!=false
			if @user.destroy
				render json: {'status'=>"0",'data'=> {
						'message': 'success'
				}.to_json}
			else
				render json: {'status'=>"1",'data'=> {
						'message': 'destroy faild'
				}.to_json}
			end
		else
			render json: {'status'=>"1",'data'=> {
						'message': '密码错误'
				}.to_json}

		end
		
	end

	private
	
	def find_user
		if params[:token]=='1'
			@user = User.find(0)
		else
			@user = User.find_by(remember_digest: params[:token])
		end
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
