class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :custom_field_definitions

  def custom_field_definitions
    object.custom_field_definitions.map do |field_def|
      {
        id: field_def.id,
        field_name: field_def.field_name,
        field_type: field_def.field_type,
        enum_options: field_def.enum_options
      }
    end
  end
end
