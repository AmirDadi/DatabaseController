class Query < ActiveRecord::Base
	belongs_to :user
	
	validate :check_grants




	def check_grants

		query = self.query_cmd
		database_id = self.database_id
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
			table_grant = TableGrant.find_by(:user_id=>self.user_id, :table => table_name, :db_id => database_id)
			if table_grant.nil? 
				errors.add(:query_cmd,"Table not found or you don't have access to '#{table_name}'")
				return false
			elsif (table_grant.access_type & type) == 0 && type != SELECT
				errors.add(:query_cmd, "Table found but you don't have this access")
			end
		end
		true
	end


	def get_tables( query)
		tables = `java -jar "JSQL Parser.jar" "#{query}"`
		if tables.split[0] == "Exception"
			raise tables
		end
		return tables.split(", ")
	end

	private
	ACCESS_TYPES = [SELECT = 1, INSERT = 2, DELETE = 4, UPDATE = 8]
end
