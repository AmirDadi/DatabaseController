class AddDatabaseToQueries < ActiveRecord::Migration
  def change
    add_column :queries, :database_id, :integer
  end
end
