class CustomFieldDefinition < ApplicationRecord
  belongs_to :client
  has_many :custom_field_values, dependent: :destroy

  enum field_type: { number: 0, freeform: 1, enum_type: 2 }

  serialize :enum_options, coder: JSON

  validates :field_name, presence: true,
                         uniqueness: { scope: :client_id, case_sensitive: false },
                         length: { minimum: 1, maximum: 50 }

  validates :field_type, presence: true
  validates :enum_options, presence: true, if: :enum_type?
  validate :enum_options_are_valid, if: :enum_type?

  before_validation :normalize_field_name

  private

  def normalize_field_name
    self.field_name = field_name.strip.downcase if field_name.present?
  end

  def enum_options_are_valid
    return unless enum_options.is_a?(Array)

    if enum_options.empty?
      errors.add(:enum_options, "must have at least one option")
    elsif enum_options.any?(&:blank?)
      errors.add(:enum_options, "cannot contain blank values")
    end
  end
end
