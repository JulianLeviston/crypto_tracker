# A specific price or rate for exchange between two currencies at a particular date/time
class ExchangeRate < ApplicationRecord
  belongs_to :currency_exchange_type
  has_one :exchange_rate_requests

  # a scope that can be used to find a currency pair for exchange record fetching
  scope :for_codes, ->(from_code, to_code) {
    # manual joins because aliasing wasn't working when using AR joins
    joins(:currency_exchange_type)
      .joins("INNER JOIN currencies AS from_currencies ON from_currencies.id = currency_exchange_types.from_currency_id")
      .joins("INNER JOIN currencies AS to_currencies ON to_currencies.id = currency_exchange_types.to_currency_id")
      .where(from_currencies: { code: from_code }, to_currencies: { code: to_code })
      .order(created_at: :desc)
  }
end
