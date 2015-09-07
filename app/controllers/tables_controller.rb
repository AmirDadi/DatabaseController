class TablesController < ApplicationController
	include ApplicationHelper
	def index
		if(@@current_database.nil?)
			@tables = nil
		else
			tg = TableGrant.new
			@tables = exec("SELECT table_name FROM information_schema.tables where table_schema='public'", tg.current_db)
		end
	end
	
	
	def show
		respond_with(@user)
	end

	def get_table_names
		exec("SELECT table_name FROM information_schema.tables where table_schema='public'", @@current_database)
	end
	private
		def tables_params
			params.require(:table).permit(:user, :password, :dbname)
		end
end