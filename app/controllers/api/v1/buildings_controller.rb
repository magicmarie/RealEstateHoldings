class Api::V1::BuildingsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def index
    # Eager load associations to prevent N+1 queries
    buildings = Building
      .includes(:client, :custom_field_values, client: :custom_field_definitions)
      .order(created_at: :desc)
      .page(params[:page] || 1)
      .per(params[:per_page] || 20)

    render json: {
      buildings: ActiveModelSerializers::SerializableResource.new(buildings, each_serializer: BuildingSerializer).as_json,
      meta: pagination_meta(buildings)
    }
  end

  def metadata
    render json: {
      us_states: Building::US_STATES
    }
  end

  def show
    building = Building
      .includes(:client, :custom_field_values, client: :custom_field_definitions)
      .find(params[:id])

    render json: building, serializer: BuildingSerializer
  end

  def create
    service = BuildingService.new

    if service.create(building_params)
      render json: service.building, serializer: BuildingSerializer, status: :created
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def update
    building = Building.find(params[:id])
    service = BuildingService.new(building)

    if service.update(building_params)
      render json: service.building, serializer: BuildingSerializer
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def building_params
    params.require(:building).permit(
      :client_id,
      :address,
      :city,
      :state,
      :zip_code,
      custom_fields: {}
    )
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end

  def record_not_found
    render json: { error: "Client or building not found" }, status: :not_found
  end

  def record_invalid(exception)
    render json: { errors: [ exception.message ] }, status: :unprocessable_entity
  end
end
