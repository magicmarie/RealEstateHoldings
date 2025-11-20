class Building < ApplicationRecord
  US_STATES = %w[
    AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD
    MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC
    SD TN TX UT VT VA WA WV WI WY DC
  ].freeze

  belongs_to :client
  has_many :custom_field_values, dependent: :destroy
  has_many :custom_field_definitions, through: :custom_field_values

  validates :address, presence: true, length: { maximum: 255 }
  validates :address, uniqueness: { scope: [:city, :state, :zip_code], message: "already exists at this location" }
  validates :city, length: { maximum: 100 }
  validates :state, presence: true,
                    format: { with: /\A[A-Z]{2}\z/, message: "must be 2-letter state code" },
                    inclusion: { in: US_STATES, message: "%{value} is not a valid US state" }
  validates :zip_code, presence: true,
                       format: { with: /\A\d{5}(-\d{4})?\z/, message: "must be valid ZIP code" }

  accepts_nested_attributes_for :custom_field_values, allow_destroy: true
end
