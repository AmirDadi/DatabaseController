class TableGrant < ActiveRecord::Base
	#associations
	belongs_to :user
	

	#validations
	validate :user, :presence => true
	validate :user_id_exists, :table_exists
	after_initialize :init

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


	cattr_accessor :current_db
	cattr_accessor :current_tables
	



	def init
		self.current_db = PG::Connection.new(dbname: 'shop', user: 'postgres', password: '1234')
		self.current_tables = current_db.exec("SELECT table_name FROM information_schema.tables where table_schema='public'")
	end

end