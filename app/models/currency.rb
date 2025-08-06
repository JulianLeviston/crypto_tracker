# Currency is one side of a CurrencyExchangeType eg AUD, BTC or ETH
class Currency < ApplicationRecord
  validates :code, presence: true
  has_many :from_currency_exchange_types, class_name: "CurrencyExchangeType", foreign_key: "from_currency_id"
  has_many :to_currency_exchange_types, class_name: "CurrencyExchangeType", foreign_key: "to_currency_id"
end
