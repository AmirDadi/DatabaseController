class AddRollbackToQueries < ActiveRecord::Migration
  def change
    add_column :queries, :roll_backed, :boolean
  end
end
