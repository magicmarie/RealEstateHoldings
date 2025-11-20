class CustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field_definition

  # Ensure that each building can have only one value per custom field definition
  validates :building_id, uniqueness: {
    scope: :custom_field_definition_id,
    message: "already has a value for this custom field"
  }

  validates :value_matches_field_type

  private

  def value_matches_field_type
    return if value.blank?

    definition = custom_field_definition

    case definition.field_type
    when 'number'
      unless numeric_string?(value)
        errors.add(:value, "must be a valid number for field '#{definition.field_name}'")
      end
    when 'enum'
      unless definition.enum_options.include?(value)
        errors.add(:value, "must be one of [#{definition.enum_options.join(', ')}] for field '#{definition.field_name}'")
      end
    when 'freeform'
      # Any string is valid
    end
  end
end
