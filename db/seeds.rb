# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# Clear existing data
[CustomFieldValue, Building, CustomFieldDefinition, Client].each(&:destroy_all)

clients_config = [
  {
    name: "Manhattan Luxury Properties",
    fields: [
      { name: "num_floors", type: :number },
      { name: "has_doorman", type: :enum_type, options: ["Yes", "No"] },
      { name: "building_amenities", type: :freeform }
    ]
  },
  {
    name: "Brooklyn Industrial Spaces",
    fields: [
      { name: "ceiling_height_ft", type: :number },
      { name: "loading_dock_type", type: :enum_type, options: ["Ground Level", "Elevated", "None"] },
      { name: "previous_use", type: :freeform }
    ]
  },
  {
    name: "Queens Residential Group",
    fields: [
      { name: "year_renovated", type: :number },
      { name: "heating_type", type: :enum_type, options: ["Gas", "Electric", "Oil", "Steam"] },
      { name: "neighborhood_notes", type: :freeform }
    ]
  },
  {
    name: "Bronx Community Housing",
    fields: [
      { name: "num_affordable_units", type: :number },
      { name: "accessibility_rating", type: :enum_type, options: ["Full", "Partial", "Limited"] },
      { name: "community_features", type: :freeform }
    ]
  },
  {
    name: "Staten Island Commercial RE",
    fields: [
      { name: "parking_spaces", type: :number },
      { name: "zoning_type", type: :enum_type, options: ["Commercial", "Mixed Use", "Industrial"] },
      { name: "special_features", type: :freeform }
    ]
  }
]

clients_config.each do |config|
  puts "Creating client: #{config[:name]}"
  client = Client.create!(name: config[:name])

  # Create field definitions
  config[:fields].each do |field|
    client.custom_field_definitions.create!(
      field_name: field[:name],
      field_type: field[:type],
      enum_options: field[:options]
    )
  end

  # Create 3-5 buildings per client
  rand(3..5).times do |i|
    building = client.buildings.create!(
      address: "#{rand(1..999)} #{['Main St', 'Broadway', 'Park Ave', 'Ocean Pkwy'].sample}",
      city: config[:name].split.first,
      state: "NY",
      zip_code: "#{10000 + rand(1..500)}"
    )

    # Add custom field values (some fields may be empty - 80% chance)
    client.custom_field_definitions.each do |field_def|
      next if rand > 0.8  # Skip 20% of the time to show empty values

      value = case field_def.field_type
      when 'number'
        rand(1..100).to_s  # Will be stored as "50" in TEXT column
      when 'enum_type'
        field_def.enum_options.sample
      when 'freeform'
        ["Excellent condition", "Recently updated", "Needs renovation", "Historic building"].sample
      end

      building.custom_field_values.create!(
        custom_field_definition: field_def,
        value: value
      )
    end

    puts "  Created building: #{building.address}"
  end
end

puts "\nSeeding complete!"
puts "Created:"
puts "  - #{Client.count} clients"
puts "  - #{CustomFieldDefinition.count} custom field definitions"
puts "  - #{Building.count} buildings"
puts "  - #{CustomFieldValue.count} custom field values"

