class BuildingService
  attr_reader :building, :errors

  def initialize(building = nil)
    @building = building || Building.new
    @errors = []
  end

  def create(params)
    validate_client_exists(params[:client_id])
    @building.assign_attributes(building_attributes(params))

    Building.transaction do
      if @building.save
        save_custom_field_values(params[:custom_fields])
        true
      else
        @errors = @building.errors.full_messages
        false
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    @errors = [ e.message ]
    false
  end

  def update(params)
    validate_client_exists(params[:client_id]) if params[:client_id].present?
    @building.assign_attributes(building_attributes(params))

    Building.transaction do
      if @building.save
        save_custom_field_values(params[:custom_fields])
        true
      else
        @errors = @building.errors.full_messages
        false
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    @errors = [ e.message ]
    false
  end

  private

  def validate_client_exists(client_id)
    Client.find(client_id)
  end

  def building_attributes(params)
    params.slice(:client_id, :address, :city, :state, :zip_code)
  end

  def save_custom_field_values(custom_fields)
    return unless custom_fields.present?

    custom_fields.each do |field_name, value|
      # Find the field definition for this client
      field_def = @building.client.custom_field_definitions.find_by(field_name: field_name)
      next unless field_def

      # Find or initialize the custom field value
      custom_field_value = @building.custom_field_values.find_or_initialize_by(
        custom_field_definition_id: field_def.id
      )

      # Update the value
      custom_field_value.value = value
      custom_field_value.save!
    end
  end
end
