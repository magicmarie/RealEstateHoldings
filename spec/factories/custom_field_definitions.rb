FactoryBot.define do
  factory :custom_field_definition do
    client { nil }
    field_name { "MyString" }
    field_type { 1 }
    enum_options { "MyText" }
  end
end
