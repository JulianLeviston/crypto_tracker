# Ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

#   Ensure necessary Currency data exists
[ { code: "AUD", description: "Australian Dollar" },
  { code: "BTC", description: "Bitcoin" },
  { code: "ETH", description: "Etherium Ether" }
].each do |currency_data|
  found_currency = Currency.find_by(code: currency_data[:code])
  found_currency || Currency.create!(currency_data)
end
