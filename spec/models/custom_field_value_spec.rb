require 'rails_helper'

RSpec.describe CustomFieldValue, type: :model do
  let(:client) { Client.create!(name: 'Test Client') }
  let(:building) { Building.create!(client: client, address: '123 Main St', city: 'Boston', state: 'MA', zip_code: '02101') }

  describe 'validations' do
    it 'validates number field type accepts numeric values' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'year_built', field_type: :number)
      field_value = CustomFieldValue.new(building: building, custom_field_definition: field_def, value: '1990')
      expect(field_value).to be_valid
    end

    it 'validates number field type rejects non-numeric values' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'year_built', field_type: :number)
      field_value = CustomFieldValue.new(building: building, custom_field_definition: field_def, value: 'not a number')
      expect(field_value).not_to be_valid
      expect(field_value.errors[:value]).to include("must be a valid number for field 'year_built'")
    end

    it 'validates freeform field type accepts any value' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'description', field_type: :freeform)
      field_value = CustomFieldValue.new(building: building, custom_field_definition: field_def, value: 'Any text here')
      expect(field_value).to be_valid
    end

    it 'validates enum_type field accepts valid enum option' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'property_type', field_type: :enum_type, enum_options: [ 'Commercial', 'Residential' ])
      field_value = CustomFieldValue.new(building: building, custom_field_definition: field_def, value: 'Commercial')
      expect(field_value).to be_valid
    end

    it 'validates enum_type field rejects invalid enum option' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'property_type', field_type: :enum_type, enum_options: [ 'Commercial', 'Residential' ])
      field_value = CustomFieldValue.new(building: building, custom_field_definition: field_def, value: 'Industrial')
      expect(field_value).not_to be_valid
      expect(field_value.errors[:value]).to include("must be one of [Commercial, Residential] for field 'property_type'")
    end
  end

  describe 'associations' do
    it 'belongs to building' do
      association = CustomFieldValue.reflect_on_association(:building)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to custom_field_definition' do
      association = CustomFieldValue.reflect_on_association(:custom_field_definition)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
