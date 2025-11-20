class Api::V1::ClientsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    clients = Rails.cache.fetch("clients_with_definitions", expires_in: 1.hour) do
      Client.includes(:custom_field_definitions).order(:name).to_a
    end

    render json: clients, each_serializer: ClientSerializer
  end

  def show
    client = Client.includes(:custom_field_definitions).find(params[:id])
    render json: client, serializer: ClientSerializer
  end

  private

  def record_not_found
    render json: { error: "Client not found" }, status: :not_found
  end
end
