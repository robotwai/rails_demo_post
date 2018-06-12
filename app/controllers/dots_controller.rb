class DotsController < ApplicationController
	def create
		p params
		p current_user.id
		@dot = Dot.new(micropost_id: params[:micropost_id],user_id: params[:commenter_id])
		if @dot.save
			# flash[:success] = "dot Created"
			render json: {'status'=>"0",'data'=> {
	        	'message': 'success',
	        	'id': @dot.id
	        	}.to_json}
			# redirect_to request.referrer || root_url
		else
			# @feed_items = []
			flash[:dagger] = "dot failed"
			render json: {'status'=>"1",'data'=> {
	        	'message': 'failed'
	        	}.to_json}
			# redirect_to request.referrer || root_url
		end
	end

	def destroy
		Dot.find(params[:id]).destroy
		render json: {'status'=>"1",'data'=> {
	        	'message': 'failed'
	        	}.to_json}
	end
end
