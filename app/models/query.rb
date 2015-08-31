class Query < ActiveRecord::Base
	# include ApplicationController.master_helper_module
	include ApplicationHelper
	belongs_to :user
	
	validate :check_grants
	after_create :set_changes

	def type
		type_string = self.query_cmd.split[0]
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

	def check_grants

		query = self.query_cmd
		database_id = self.database_id
		type_string = query.split[0]
		type = self.type

		tables_in_query = get_tables(query, type)
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


	def get_tables( query, type )
		tables = `java -jar "JSQL Parser.jar" "#{query}"`
		if tables.split[0] == "Exception"
			raise tables
		end
		if type == UPDATE or type == DELETE
			tables = tables.lines.last
		end
		return tables.split(", ")
	end


	def set_changes
		table = get_tables(self.query_cmd, self.type)[0]		
		if self.type == DELETE
			set_delete_changes(table)
		elsif self.type == UPDATE
			set_update_changes(table)
		end
	end

	def set_update_changes(table)
		attributes = get_table_attributes(table, self.database_id)
		attributes = attributes.to_s.tr("[]\"",'')
		function = "WITH rows as (#{self.query_cmd} returning  #{attributes}) select * from rows"
		Rails.logger.debug("\n\n\n#{function}\n\n\n")
		result = exec_query_db(function, self.database_id)
		table = []
		result.each do |row|
			table << row
		end
		
		table.each do |row|
			statement = ""
			row.each do |key, value|
				statement = "#{key}=#{value},"
			end
			change = Change.new(:query_id=>self.id, :row => statement[0..statement.size-2])
			change.save!
		end
	end

	def set_delete_changes(table)
		where = get_where(self.query_cmd)
		
		where = "" if where == 'null'

		rows_affected = exec_query_db("select * from #{table} where #{where}",self.database_id)

		rows_affected.each do |row|
			keys = ""
			values = ""
			row.each do |key,value|
				keys = keys + key + ","
				value="" if value.nil?
				values = values + "'"+value+"'" + " ,"
			end

			data = "(#{keys[0..keys.size-2]}) VALUES (#{values[0..values.size-2]})"

			change = Change.new(:query_id=>self.id, :row=>data)
			change.save!
		end
	end

	private
	ACCESS_TYPES = [SELECT = 1, INSERT = 2, DELETE = 4, UPDATE = 8]
end
