class BuildingSerializer < ActiveModel::Serializer
  attributes :id, :address, :city, :state, :zip_code, :client_id, :client_name, :custom_fields

  def client_id
    object.client_id
  end

  def client_name
    object.client.name
  end

  def custom_fields
    # Get all field definitions for this client
    field_definitions = object.client.custom_field_definitions
    values_by_def_id = object.custom_field_values.index_by(&:custom_field_definition_id)

    # Build custom fields hash - only values, not definitions
    # Frontend will have definitions from the clients endpoint
    field_definitions.each_with_object({}) do |definition, hash|
      value = values_by_def_id[definition.id]
      hash[definition.field_name] = value&.value || ""
    end
  end
end
