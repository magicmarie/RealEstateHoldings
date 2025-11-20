class CustomFieldDefinition < ApplicationRecord
  belongs_to :client
  has_many :custom_field_values, dependent: :destroy

  enum field_type: { number: 0, freeform: 1, enum: 2 }

  validates :field_name, presence: true,
                         uniqueness: { scope: :client_id, case_sensitive: false },
                         length: { minimum: 1, maximum: 50 }

  validates :field_type, presence: true

  before_validation :normalize_field_name

  private

  def normalize_field_name
    self.field_name = field_name.strip.downcase if field_name.present?
  end
end
