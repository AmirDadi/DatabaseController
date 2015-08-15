class CreateTableGrants < ActiveRecord::Migration
  def change
    create_table :table_grants do |t|
      t.integer :user_id
      t.integer :db_id
      t.string :table
      t.string :type

      t.timestamps
    end
  end
end
