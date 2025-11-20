module ClientCacheable
  extend ActiveSupport::Concern

  included do
    after_save :clear_clients_cache
    after_destroy :clear_clients_cache
  end

  private

  # Clear the cached clients with definitions
  def clear_clients_cache
    Rails.cache.delete("clients_with_definitions")
  end
end
