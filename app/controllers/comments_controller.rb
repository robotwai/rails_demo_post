class CommentsController < ApplicationController
	

	def create
		p params
		p current_user.id
		@comment = Comment.new(micropost_id: params[:micropost_id],body: params[:comment][:body],user_id: params[:commenter_id])
		respond_to do |format|
			if @comment.save
				format.html {
					flash[:success] = "comment Created"
					redirect_to request.referrer || root_url
				}
				format.js
				
			else
				format.html {
					flash[:dagger] = "comment failed"
					redirect_to request.referrer || root_url
				}
				
			end
		end
	end

	def destory
		
	end



	private
	def comment_params
  		params.require(:comment).permit(:body,:micropost_id)
  	end
end
