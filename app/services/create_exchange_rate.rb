# Semantic service that wraps the creation of an exchange rate.
# We choose to use the standard created_at here instead of the passed
# time from the API. Noting this here because we may want to record the
# time from the API as well, depending if there are differences.
class CreateExchangeRate
  attr_reader :exchange_rate_attributes

  def initialize(exchange_rate_attributes)
    @exchange_rate_attributes = exchange_rate_attributes
  end

  def call
    ExchangeRate.create!(price_properties)
  end
end
