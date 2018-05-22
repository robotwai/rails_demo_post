class DotsController < ApplicationController
	def create
		p params
		p current_user.id
		@comment = Comment.new(micropost_id: params[:micropost_id],user_id: params[:commenter_id])
		if @comment.save
			flash[:success] = "comment Created"
			redirect_to request.referrer || root_url
		else
			# @feed_items = []
			flash[:dagger] = "comment failed"
			redirect_to request.referrer || root_url
		end
	end
end
