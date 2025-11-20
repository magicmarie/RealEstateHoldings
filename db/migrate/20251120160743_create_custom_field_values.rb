class CreateCustomFieldValues < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_field_values do |t|
      t.references :building, null: false, foreign_key: true
      t.references :custom_field_definition, null: false, foreign_key: true
      t.text :value

      t.timestamps
    end
    # ensure a building cannot have two custom field values for the same custom field definition
    add_index :custom_field_values, [:building_id, :custom_field_definition_id], unique: true
  end
end
