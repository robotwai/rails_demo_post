class CommentsController < ApplicationController
	

	def create
		p params
		@comment = Comment.new(micropost_id: params[:micropost_id],body: params[:comment][:body])
		if @comment.save
			flash[:success] = "comment Created"
			redirect_to root_url
		else
			# @feed_items = []

			redirect_to root_url
		end
	end



	private
	def comment_params
  		params.require(:comment).permit(:body,:micropost_id)
  	end
end
