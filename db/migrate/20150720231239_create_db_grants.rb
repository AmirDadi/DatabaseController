class CreateDbGrants < ActiveRecord::Migration
  def change
    create_table :db_grants do |t|
      t.integer :user_id
      t.string :db
      t.string :type

      t.timestamps
    end
  end
end
