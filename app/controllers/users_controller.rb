class UsersController < ApplicationController
	  before_action :set_user, only: [:show, :edit, :update, :destroy]


	before_filter :ensure_admin!, except: [:set_database]
	

	

  respond_to :html
	def create
		@user = User.new(user_params)
		@user.save
		redirect_to root_path
	end

	def new
		@user= User.new
		@user.save

	end

	def index
		@users = User.all
	end
	def show
	end	

	def destroy
		@user.destroy
		redirect_to '/table_grants'
	end

	def edit
	end

	def set_database
    	current_user.db_id = params[:db_id]
    	current_user.save
    	redirect_to(:back)
    end

    def invert_admin
    	@user = User.find(params[:id])
    	@user.admin = (not @user.admin)
    	@user.save
    	redirect_to(:back)
    end
	private
	def set_user
      @user = User.find(params[:id])
    end
	def user_params
		params.require(:user).permit(:email, :password, :db_id)
	end
	def ensure_admin!
		unless current_user && current_user.admin?
			redirect_to root_path, notice: "You are not admin"
			return false
		end
	end
end