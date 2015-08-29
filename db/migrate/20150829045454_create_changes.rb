class CreateChanges < ActiveRecord::Migration
  def change
    create_table :changes do |t|
      t.integer :query_id
      t.string :row

      t.timestamps
    end
  end
end
