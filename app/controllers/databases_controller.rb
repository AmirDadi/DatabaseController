class DatabasesController <AdminController
	def new
		@database = Database.new
	end
	def create
		@database = Database.new(databse_params)
		@database.save
		redirect_to 'new'
	end

	


	private
	def database_params
		params.require(:database).permit(:name)
	end
end