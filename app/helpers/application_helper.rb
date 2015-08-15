module ApplicationHelper
	ACCESS_TYPES = [SELECT = 1, INSERT = 2, DELETE = 4, UPDATE = 8]
	def tables_of_user(user_id, database)
		if User.find(user_id).admin
			temp_tables = database.exec("SELECT table_name FROM information_schema.tables where table_schema='public'")
			tables = Hash.new
			temp_tables.each do |row|
				tables[row["table_name"]] = SELECT | INSERT | DELETE | UPDATE
			end
			tables
		else
			tables = Hash.new
			TableGrant.where(:user_id => user_id, :db_id => current_user.db_id).each do |grant|
				puts grant[:table]
				tables[grant[:table]] = grant[:access_type]
			end

			tables
		end
	end


	def db_of_user(user_id, database)
		Database.all
	end

	def select_query(query, database)
		begin
			result = database.exec(query)
		rescue PG::Error => e 
			raise e
		end
		table = []
		result.each do |row|
			table << row
		end
		table
	end


	def connect_db(database)
		PG::Connection.new(dbname: database, user: 'postgres', password: '1234')
	end

	def get_database
		return [] if current_user.db_id.nil?
		connect_db(Database.find(current_user.db_id).name)
	end

	def get_all_tables
		return [] if current_user.db_id.nil?
		current_db = PG::Connection.new(dbname: Database.find(current_user.db_id).name, user: 'postgres', password: '1234')
		tables = current_db.exec("SELECT table_name FROM information_schema.tables where table_schema='public'")
		table_names = []
	    tables.each do |row|
	      table_names << row['table_name']
    end
    table_names
	end

	def execute_query(query, db_name)
		db = connect_db(db_name)
		db.exec(query)
	end


	def check_grants(query, database_id)
		type_string = query.split[0]
		type = 0
		if type_string.casecmp("INSERT")==0
			type = INSERT
		elsif type_string.casecmp("DELETE")==0
			type = DELETE
		elsif type_string.casecmp("UPDATE")==0 || type_string.casecmp("ALTER") == 0
			type = UPDATE
		elsif type_string.casecmp("SELECT")==0
			type = SELECT
		else
			type = -1
		end

		tables_in_query = get_tables(query)
		tables_in_query.each do |table|
			table_name = table
			table_grant = TableGrant.find_by(:user_id=>current_user.id, :table => table_name, :db_id => database_id)
			if table_grant.nil? 
				raise "Table not found or you don't have access to #{table_name}"
			elsif (table_grant.access_type & type) == 0 && type != SELECT
				return false
			end
		end
		true
	end


	def get_tables( query)
		tables = `java -jar "JSQL Parser.jar" "#{query}"`
		if tables.split[0] == "Exception"
			raise tables
		end
		return tables.split(",")
	end
end

# `jruby ./query_parser.rb "UPDATE Customers SET ContactName='Alfred Schmidt', City='Hamburg' WHERE CustomerName='Alfreds Futterkiste'"`
