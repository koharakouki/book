class PostbooksController < ApplicationController
	before_action :logged_in_user, only: [:create, :edit, :update, :destroy]

	def show
		@post = Postbook.find(params[:id])
		@postbook = current_user.postbooks.build if logged_in?
		@user = User.find(@post.user.id)
	end


	def create
		@postbook = current_user.postbooks.build(postbook_params)
		if @postbook.save
			flash[:success] = "post successfully"
			redirect_to postbook_path(@postbook)
		else
			render 'index'
		end
	end

	def index
		@postbook = current_user.postbooks.build if logged_in?
		@postbooks = Postbook.all
		@user = User.find(current_user.id)
	end

	def edit
		@postbook = current_user.postbooks.find(params[:id])
	end

	def update
		@postbook = current_user.postbooks.find(params[:id])
		if @postbook.update_attributes(postbook_params)
    	   flash[:success] = "Post updated successfully"
           redirect_to postbook_url(@postbook)
        else
           render 'edit'
       end
	end

	def destroy
	end

	private

	def postbook_params
		params.require(:postbook).permit(:title, :body)
	end

end
