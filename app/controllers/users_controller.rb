class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  def new
  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
    @user = User.find(current_user.id)
    @postbook = current_user.postbooks.build if logged_in?
  end

  def show
  	@user = User.find(params[:id])
    @postbook = current_user.postbooks.build if logged_in?
    @postbooks = @user.postbooks.paginate(page: params[:page])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
       log_in @user
  		 flash[:success] = "Welcome to the Bookers!"
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
      flash[:success] = "Profile updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation, :introduction, :profile_image_id)
  end


  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end


end
