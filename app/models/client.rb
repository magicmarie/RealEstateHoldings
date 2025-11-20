class Client < ApplicationRecord
  has_many :buildings, dependent: :destroy
  has_many :custom_field_definitions, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 2, maximum: 100 }

  # prevent duplicates due to leading/trailing spaces
  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.strip if name.present?
  end
end
