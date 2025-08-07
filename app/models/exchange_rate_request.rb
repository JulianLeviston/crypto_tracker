# Record representing the fetching & processing of data for a particular currency exchange type
# If status is completed and exchange rate is missing, it failed with reason (if present)
class ExchangeRateRequest < ApplicationRecord
  enum :status, { pending: 0, in_progress: 1, completed: 2 }
  belongs_to :currency_exchange_type
  belongs_to :exchange_rate

  def url
    currencty_exchange_type.exchange_rate_url
  end
end
