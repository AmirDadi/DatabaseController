class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.text :query_cmd
      t.integer :user_id
      t.datetime :time
      t.text :type

      t.timestamps
    end
  end
end
