class ChangeAccessTypeInGrant < ActiveRecord::Migration
  def change
  	change_column :table_grants, :access_type, 'integer USING CAST(access_type AS integer)'
  end
end
