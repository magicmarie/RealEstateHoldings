class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false

      t.timestamps
    end
    
    # ensure name uniqueness at the database level
    add_index :clients, :name, unique: true
  end
end
