require 'rails_helper'

RSpec.describe 'Api::V1::Clients', type: :request do
  let!(:client) { Client.create!(name: 'Test Client') }
  let!(:field_def) { CustomFieldDefinition.create!(client: client, field_name: 'year_built', field_type: :number) }

  describe 'GET /api/v1/clients' do
    it 'returns all clients with their field definitions' do
      get '/api/v1/clients'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to be >= 1
      expect(json.first['name']).to eq('Test Client')
      expect(json.first['custom_field_definitions']).to be_present
    end
  end

  describe 'GET /api/v1/clients/:id' do
    it 'returns a specific client' do
      get "/api/v1/clients/#{client.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('Test Client')
      expect(json['custom_field_definitions'].length).to eq(1)
    end

    it 'returns 404 for non-existent client' do
      get '/api/v1/clients/99999'
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Client not found')
    end
  end
end
