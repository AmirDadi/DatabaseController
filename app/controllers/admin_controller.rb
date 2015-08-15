class AdminController <ApplicationController
	before_filter :ensure_admin!
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
	
	private	
	def ensure_admin!
		unless current_user && current_user.admin?
			redirect_to root_path, notice: "You are not admin"
			return false
		end
	end
	def set_user
      @user = User.find(params[:id])
    end
	def user_params
		params.require(:user).permit(:email, :password, :db_id)
	end
end