class DbGrant < ActiveRecord::Base
	belongs_to :user
	validate :user, :presence => true
end
