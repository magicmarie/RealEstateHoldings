require 'rails_helper'

RSpec.describe CustomFieldDefinition, type: :model do
  let(:client) { Client.create!(name: 'Test Client') }

  describe 'validations' do
    it 'validates presence of field_name' do
      field_def = CustomFieldDefinition.new(client: client, field_type: :number)
      expect(field_def).not_to be_valid
      expect(field_def.errors[:field_name]).to include("can't be blank")
    end

    it 'validates presence of field_type' do
      field_def = CustomFieldDefinition.new(client: client, field_name: 'year_built')
      expect(field_def).not_to be_valid
      expect(field_def.errors[:field_type]).to include("can't be blank")
    end

    it 'validates uniqueness of field_name scoped to client' do
      CustomFieldDefinition.create!(client: client, field_name: 'year_built', field_type: :number)
      field_def = CustomFieldDefinition.new(client: client, field_name: 'year_built', field_type: :freeform)
      expect(field_def).not_to be_valid
      expect(field_def.errors[:field_name]).to include('has already been taken')
    end

    it 'allows same field_name for different clients' do
      other_client = Client.create!(name: 'Other Client')
      CustomFieldDefinition.create!(client: client, field_name: 'year_built', field_type: :number)
      field_def = CustomFieldDefinition.new(client: other_client, field_name: 'year_built', field_type: :number)
      expect(field_def).to be_valid
    end

    it 'validates enum_options presence for enum_type fields' do
      field_def = CustomFieldDefinition.new(client: client, field_name: 'property_type', field_type: :enum_type)
      expect(field_def).not_to be_valid
      expect(field_def.errors[:enum_options]).to include("can't be blank")
    end

    it 'does not require enum_options for non-enum fields' do
      field_def = CustomFieldDefinition.new(client: client, field_name: 'year_built', field_type: :number)
      expect(field_def).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to client' do
      association = CustomFieldDefinition.reflect_on_association(:client)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many custom_field_values' do
      association = CustomFieldDefinition.reflect_on_association(:custom_field_values)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'field types' do
    it 'accepts number field type' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'year_built', field_type: :number)
      expect(field_def.field_type).to eq('number')
    end

    it 'accepts freeform field type' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'description', field_type: :freeform)
      expect(field_def.field_type).to eq('freeform')
    end

    it 'accepts enum_type field type' do
      field_def = CustomFieldDefinition.create!(client: client, field_name: 'property_type', field_type: :enum_type, enum_options: ['Commercial', 'Residential'])
      expect(field_def.field_type).to eq('enum_type')
    end
  end
end
