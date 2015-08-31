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

	def exec_query(query)
		db = get_database
		db.exec(query)
	end

	def exec_query_db(query, db_id)
		db = connect_db(Database.find(db_id).name)
		db.exec(query)
	end

	def type_of(query)
		type_string = query.split[0]
		if type_string.casecmp("INSERT")==0
			INSERT
		elsif type_string.casecmp("DELETE")==0
			DELETE
		elsif type_string.casecmp("UPDATE")==0 || type_string.casecmp("ALTER") == 0
			UPDATE
		elsif type_string.casecmp("SELECT")==0
			SELECT
		else
			-1
		end
	end


	def repair_alter(cmd)
		revised_cmd = cmd.gsub('(','')
		revised_cmd = revised_cmd.gsub(')','')
		type = revised_cmd.split()[0]
	end

	def get_tables( query, type)
		tables = `java -jar "JSQL Parser.jar" "#{query}"`
		if tables.split[0] == "Exception"
			raise tables
		end

		if (type == DELETE or type == UPDATE)
			tables = tables.split('\n').last
		end
		return tables.split(", ")
	end

	def get_where(query)
		tables = `java -jar "JSQL Parser.jar" "#{query}"`
		if tables.split[0] == "Exception"
			raise tables
		end
		tables.lines.first
	end

	def get_rollback_insert(query)
		result = `java -jar "JSQL Parser.jar" insert "#{query}"`
		if result.split[0] == "Exception"
			raise result
		end
		columns = result.lines.first.tr("[]\n'",'').split(',')
		values = result.lines.last.tr("[]()\n'",'').split(',')
		s=''
		for i in 0..columns.size-1
			s = s + columns[i] + "='" + values[i] + "'"
			if i != columns.size-1
				s = s + ' AND '
			end
		end
		s
	end


	def get_table_attributes(table, db_id)
		query = "SELECT * FROM #{table}"
		res = exec_query_db(query, db_id)
		attributes = []

		table = []
		res.each do |row|
			table << row
		end
		puts table
		table[0].each_key do |key|
			attributes << key
		end
		attributes

	end

	private
	
end

# `jruby ./query_parser.rb "UPDATE Customers SET ContactName='Alfred Schmidt', City='Hamburg' WHERE CustomerName='Alfreds Futterkiste'"`