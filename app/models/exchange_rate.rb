# A specific price or rate for exchange between two currencies at a particular date/time
class ExchangeRate < ApplicationRecord
  belongs_to :currency_exchange_type
end
