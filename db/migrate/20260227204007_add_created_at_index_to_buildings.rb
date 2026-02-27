class AddCreatedAtIndexToBuildings < ActiveRecord::Migration[7.2]
  def change
    add_index :buildings, :created_at
  end
end
