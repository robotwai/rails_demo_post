class CommentsController < ApplicationController
	

	def create
		p params
		p current_user.id
		@comment = Comment.new(micropost_id: params[:micropost_id],body: params[:comment][:body],user_id: params[:commenter_id])
		if @comment.save
			flash[:success] = "comment Created"
			redirect_to request.referrer || root_url
		else
			# @feed_items = []
			flash[:dagger] = "comment failed"
			redirect_to request.referrer || root_url
		end
	end

	def destory
		
	end



	private
	def comment_params
  		params.require(:comment).permit(:body,:micropost_id)
  	end
end
