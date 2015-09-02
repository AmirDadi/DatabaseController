class DatabasesController <AdminController
	def new
		@database = Database.new
		@database.save
	end
	def create
		@database = Database.new(:name => params[:database])
		@database.save
		redirect_to '/queries'
	end

	


	private
	def database_params
		params.require(:database).permit(:name)
	end
end