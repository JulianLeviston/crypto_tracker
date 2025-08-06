# CurrencyExchangeType is the type of an ExchangeRate eg BTCAUD or ETHAUD including its source url
class CurrencyExchangeType < ApplicationRecord
  belongs_to :from_currency, class_name: "Currency"
  belongs_to :to_currency, class_name: "Currency"
end
