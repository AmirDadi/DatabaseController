class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
 #  helper_mehtod :tables_of_user
	# ACCESS_TYPES = [READ = 1, INSERT = 2, DELETE = 4, UPDATE = 8]
	# def tables_of_user(user_id, database)
	# 	if User.find(user_id).admin
	# 		temp_tables = database.current_db.exec("SELECT table_name FROM information_schema.tables where table_schema='public'")
	# 		tables = Hash.new
	# 		tamp_tables.each do |row|
	# 			tables[temp_tables["table_name"]] = READ | INSERT | DELETE | UPDATE
	# 		end
	# 		tables
	# 	else
	# 		tables = Hash.new
	# 		TableGrant.where(:user_id => user_id).each do |grant|
	# 			tables[grant[:table]] = grant[:access_type]
	# 		end
	# 		tables
	# 	end
	# end
end





