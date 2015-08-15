class TablesController < ApplicationController

	def index
		if(@@current_database.nil?)
			@tables = nil
		else
			tg = TableGrant.new
			@tables = tg.current_db.exec("SELECT table_name FROM information_schema.tables where table_schema='public'")
		end
	end
	
	
	def show
		respond_with(@user)
	end

	def get_table_names
		@@current_database.exec("SELECT table_name FROM information_schema.tables where table_schema='public'")
	end
	private
		def tables_params
			params.require(:table).permit(:user, :password, :dbname)
		end
end