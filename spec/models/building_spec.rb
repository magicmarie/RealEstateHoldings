require 'rails_helper'

RSpec.describe Building, type: :model do
  let(:client) { Client.create!(name: 'Test Client') }

  describe 'validations' do
    it 'validates presence of address' do
      building = Building.new(client: client, city: 'Boston', state: 'MA', zip_code: '02101')
      expect(building).not_to be_valid
      expect(building.errors[:address]).to include("can't be blank")
    end

    it 'validates presence of state' do
      building = Building.new(client: client, address: '123 Main St', zip_code: '02101')
      expect(building).not_to be_valid
      expect(building.errors[:state]).to include("can't be blank")
    end

    it 'validates state format' do
      building = Building.new(client: client, address: '123 Main St', state: 'Massachusetts', zip_code: '02101')
      expect(building).not_to be_valid
      expect(building.errors[:state]).to include('must be 2-letter state code')
    end

    it 'validates zip code format' do
      building = Building.new(client: client, address: '123 Main St', state: 'MA', zip_code: '123')
      expect(building).not_to be_valid
      expect(building.errors[:zip_code]).to include('must be valid ZIP code')
    end

    it 'validates uniqueness of address at same location' do
      Building.create!(client: client, address: '123 Main St', city: 'Boston', state: 'MA', zip_code: '02101')
      building = Building.new(client: client, address: '123 Main St', city: 'Boston', state: 'MA', zip_code: '02101')
      expect(building).not_to be_valid
      expect(building.errors[:address]).to include('already exists at this location')
    end

    it 'creates valid building' do
      building = Building.new(client: client, address: '123 Main St', city: 'Boston', state: 'MA', zip_code: '02101')
      expect(building).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to client' do
      association = Building.reflect_on_association(:client)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many custom_field_values' do
      association = Building.reflect_on_association(:custom_field_values)
      expect(association.macro).to eq(:has_many)
    end
  end
end
