class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost= current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @comment = @micropost.comments.build
    end
  end

  def help
  end

  def about
  end

  def json
  	respond_to do |format|
      format.json { render json: { msg: "hi,index" } }
      format.html { render "index,hi"}
    end
  end
end
