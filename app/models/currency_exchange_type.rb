# Type of an ExchangeRate eg BTCAUD or ETHAUD including its source url
class CurrencyExchangeType < ApplicationRecord
  belongs_to :from_currency, class_name: "Currency"
  belongs_to :to_currency, class_name: "Currency"
  has_many :exchange_rates
  has_many :exchange_rate_requests
  # Using created_at as the API exchange rate datetime for current exchange rate
  has_one :current_exchange_rate, -> { order(created_at: :desc) }, class_name: "ExchangeRate"
end
