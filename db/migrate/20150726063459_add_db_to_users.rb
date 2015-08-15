class AddDbToUsers < ActiveRecord::Migration
  def change
    add_column :users, :db_id, :integer
  end
end
