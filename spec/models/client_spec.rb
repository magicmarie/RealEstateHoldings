require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      client = Client.new(name: nil)
      expect(client).not_to be_valid
      expect(client.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of name' do
      Client.create!(name: 'ABC Corp')
      client = Client.new(name: 'ABC Corp')
      expect(client).not_to be_valid
      expect(client.errors[:name]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many buildings' do
      association = Client.reflect_on_association(:buildings)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many custom_field_definitions' do
      association = Client.reflect_on_association(:custom_field_definitions)
      expect(association.macro).to eq(:has_many)
    end
  end
end
