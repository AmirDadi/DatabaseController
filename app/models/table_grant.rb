class TableGrant < ActiveRecord::Base
	#associations
	belongs_to :user
	
	validate :table,  :presence => true
	#validations
	validate :user, :presence => true
	validate :user_id_exists, :table_exists, :db_id_exists
	validate :valid_access_type
	
	after_initialize :init

	def db_id_exists
		begin
			Database.find(self.db_id)
		rescue ActiveRecord::RecordNotFound
			errors.add(:db_id, "db_id foreign key most exists")
			false
		end
	end

	def user_id_exists
		begin
	  		User.find(self.user_id)
	 	rescue ActiveRecord::RecordNotFound
	  	    errors.add(:user_id, "user_id foreign key must exist")
		    false
		end
	end

	def table_exists
		if (self.current_tables.detect {|f| f["table_name"] == self.table}).nil?
			errors.add(:table, "table foreign key must exist")
			false
		else
			true
		end
	end

	def valid_access_type
		if(self.access_type>15 || self.access_type < 1)
			errors.add(:access_type, "Access_type is not valid")
			false
		end
	end


	cattr_accessor :current_db
	cattr_accessor :current_tables
	



	def init
		self.current_db = PG::Connection.new(dbname: 'shop', user: 'postgres', password: '1234')
		self.current_tables = current_db.exec("SELECT table_name FROM information_schema.tables where table_schema='public'")
	end

end