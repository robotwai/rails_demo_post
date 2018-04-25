class UsersController < ApplicationController
  before_action :looged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  	# debugger
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "Wellcome to the Sample App"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.all
  end

  private

  	def user_params
  		params.require(:user).permit(:name,:email,:password,:password_confirmation)
  	end

    def looged_in_user
      unless  logged_in?
        store_location
        flash[:dagger] = "Please log in"
        redirect_to login_url
        
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end
