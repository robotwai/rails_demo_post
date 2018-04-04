class StaticPagesController < ApplicationController
  def home
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
