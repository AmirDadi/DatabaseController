module QuereisHelper
	ACCESS_TYPES = [SELECT = 1, INSERT = 2, DELETE = 4, UPDATE = 8]
	def set_changes(query)
		type = type_of_quer(query)
		if ( type != DELETE or type != UPDATE)
			return
		end

		where = get_where(query)
		table = get_tables[0]
		where = "" if where == 'null'
		rows_affected = exec_query("select * from #{table} where #{where}")
		rows_affected.each do |row|
			change = Changes.new(query_id=>query.id, row=>row)
			change.save
		end

	end
end
