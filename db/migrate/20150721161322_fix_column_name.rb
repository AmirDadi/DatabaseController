class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :table_grants, :type, :access_type
  	rename_column :db_grants, :type, :access_type
  end
end
