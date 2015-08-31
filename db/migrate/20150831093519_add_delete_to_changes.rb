class AddDeleteToChanges < ActiveRecord::Migration
  def change
    add_column :changes, :delete_or_insert, :boolean
  end
end
