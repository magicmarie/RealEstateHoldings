FactoryBot.define do
  factory :custom_field_value do
    building { nil }
    custom_field_definition { nil }
    value_number { "9.99" }
    value_text { "MyText" }
    value_enum { "MyString" }
  end
end
