# A specific price or rate for exchange between two currencies at a particular date/time
class ExchangeRate < ApplicationRecord
  belongs_to :currency_exchange_type
  has_one :exchange_rate_requests
end
