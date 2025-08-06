# Ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Ensure necessary Currency data exists
[ { code: "AUD", description: "Australian Dollar" },
  { code: "BTC", description: "Bitcoin" },
  { code: "ETH", description: "Etherium Ether" }
].each do |currency_data|
  found_currency = Currency.find_by(code: currency_data[:code])
  found_currency || Currency.create!(currency_data)
end

# Ensure necessary CurrencyExchangeType data exists
to_currency = Currency.find_by(code: "AUD")
[ "BTC", "ETH" ].each do |currency_code|
  from_currency = Currency.find_by(code: currency_code)
  found_currency_exchange_type = CurrencyExchangeType.find_by(
    from_currency: from_currency,
    to_currency: to_currency
  )
  if !found_currency_exchange_type
    currency_pair_code = "#{from_currency.code}#{to_currency.code}"
    currency_exchange_type_url = "https://data.exchange.coinjar.com/products/#{currency_pair_code}/ticker"
    CurrencyExchangeType.create!(
      from_currency: from_currency,
      to_currency: to_currency,
      exchange_rate_url: currency_exchange_type_url
    )
  end
end
