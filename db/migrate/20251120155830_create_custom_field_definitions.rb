class CreateCustomFieldDefinitions < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_field_definitions do |t|
      t.references :client, null: false, foreign_key: true
      t.string :field_name
      t.integer :field_type
      t.text :enum_options

      t.timestamps
    end
    # ensure a client cannot have two custom field definitions with the same field name
    add_index :custom_field_definitions, [:client_id, :field_name], unique: true
  end
end
