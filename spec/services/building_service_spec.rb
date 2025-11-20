require 'rails_helper'

RSpec.describe BuildingService do
  let(:client) { Client.create!(name: 'Test Client') }
  let(:field_def) { CustomFieldDefinition.create!(client: client, field_name: 'year_built', field_type: :number) }

  describe '#create' do
    it 'creates a building with valid params' do
      params = {
        client_id: client.id,
        address: '123 Main St',
        city: 'Boston',
        state: 'MA',
        zip_code: '02101'
      }
      service = BuildingService.new
      expect(service.create(params)).to be true
      expect(service.building).to be_persisted
      expect(service.building.address).to eq('123 Main St')
    end

    it 'creates a building with custom fields' do
      field_def # Ensure the field definition exists
      params = {
        client_id: client.id,
        address: '123 Main St',
        city: 'Boston',
        state: 'MA',
        zip_code: '02101',
        custom_fields: {
          'year_built' => '1990'
        }
      }
      service = BuildingService.new
      expect(service.create(params)).to be true
      service.building.reload
      expect(service.building.custom_field_values.count).to eq(1)
      expect(service.building.custom_field_values.first.value).to eq('1990')
    end

    it 'raises error for non-existent client' do
      params = {
        client_id: 99999,
        address: '123 Main St',
        city: 'Boston',
        state: 'MA',
        zip_code: '02101'
      }
      service = BuildingService.new
      expect { service.create(params) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns false and sets errors for invalid building' do
      params = {
        client_id: client.id,
        address: '',
        city: 'Boston',
        state: 'MA',
        zip_code: '02101'
      }
      service = BuildingService.new
      expect(service.create(params)).to be false
      expect(service.errors).to include("Address can't be blank")
    end
  end

  describe '#update' do
    let(:building) { Building.create!(client: client, address: '100 Main St', city: 'Boston', state: 'MA', zip_code: '02101') }

    it 'updates a building with valid params' do
      params = {
        address: '101 Main St'
      }
      service = BuildingService.new(building)
      expect(service.update(params)).to be true
      expect(building.reload.address).to eq('101 Main St')
    end

    it 'updates custom fields' do
      field_def # Ensure the field definition exists
      params = {
        custom_fields: {
          'year_built' => '2000'
        }
      }
      service = BuildingService.new(building)
      expect(service.update(params)).to be true
      building.reload
      expect(building.custom_field_values.count).to eq(1)
      expect(building.custom_field_values.first.value).to eq('2000')
    end

    it 'raises error when changing to non-existent client' do
      params = {
        client_id: 99999
      }
      service = BuildingService.new(building)
      expect { service.update(params) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns false and sets errors for invalid update' do
      params = {
        address: ''
      }
      service = BuildingService.new(building)
      expect(service.update(params)).to be false
      expect(service.errors).to include("Address can't be blank")
    end
  end

  describe '#errors' do
    it 'returns empty array initially' do
      service = BuildingService.new
      expect(service.errors).to eq([])
    end
  end
end
