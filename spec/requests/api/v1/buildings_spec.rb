require 'rails_helper'

RSpec.describe 'Api::V1::Buildings', type: :request do
  let!(:client) { Client.create!(name: 'Test Client') }
  let!(:building) { Building.create!(client: client, address: '100 Main St', city: 'Boston', state: 'MA', zip_code: '02101') }

  describe 'GET /api/v1/buildings' do
    it 'returns all buildings' do
      get '/api/v1/buildings'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to be >= 1
    end
  end

  describe 'GET /api/v1/buildings/:id' do
    it 'returns a specific building' do
      get "/api/v1/buildings/#{building.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['address']).to eq('100 Main St')
    end

    it 'returns 404 for non-existent building' do
      get '/api/v1/buildings/99999'
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Client or building not found')
    end
  end

  describe 'POST /api/v1/buildings' do
    it 'creates a new building' do
      params = {
        building: {
          client_id: client.id,
          address: '200 Main St',
          city: 'Cambridge',
          state: 'MA',
          zip_code: '02139'
        }
      }
      post '/api/v1/buildings', params: params, as: :json
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['address']).to eq('200 Main St')
    end

    it 'returns 404 for invalid client' do
      params = {
        building: {
          client_id: 99999,
          address: '200 Main St',
          city: 'Cambridge',
          state: 'MA',
          zip_code: '02139'
        }
      }
      post '/api/v1/buildings', params: params, as: :json
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 422 for invalid data' do
      params = {
        building: {
          client_id: client.id,
          address: '',
          city: 'Cambridge',
          state: 'MA',
          zip_code: '02139'
        }
      }
      post '/api/v1/buildings', params: params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Address can't be blank")
    end
  end

  describe 'PATCH /api/v1/buildings/:id' do
    it 'updates a building' do
      params = {
        building: {
          address: '101 Main St'
        }
      }
      patch "/api/v1/buildings/#{building.id}", params: params, as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['address']).to eq('101 Main St')
    end

    it 'returns 404 for non-existent building' do
      params = {
        building: {
          address: '101 Main St'
        }
      }
      patch '/api/v1/buildings/99999', params: params, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
