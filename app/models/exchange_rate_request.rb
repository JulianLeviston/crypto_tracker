# Record representing the fetching & processing of data for a particular currency exchange type
class ExchangeRateRequest < ApplicationRecord
  enum :status, { pending: 0, in_progress: 1, completed: 2 }
  belongs_to :currency_exchange_type
  belongs_to :exchange_rate
end
