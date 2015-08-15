class Database < ActiveRecord::Base
	validates :name, :presence => true
end
