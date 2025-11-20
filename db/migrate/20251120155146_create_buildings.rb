class CreateBuildings < ActiveRecord::Migration[7.2]
  def change
    create_table :buildings do |t|
      t.references :client, null: false, foreign_key: true
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false

      t.timestamps
    end

    # ensure a client cannot have two buildings with the same address
    add_index :buildings, [ :client_id, :address, :city, :state, :zip_code ], unique: true
  end
end
