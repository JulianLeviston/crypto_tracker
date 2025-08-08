# Semantic service that wraps the creation of an exchange rate.
# We choose to use the standard created_at here, overwritten by the passed
# current time from the API if present. Noting this here because we may want to
# change this to record the time from the API separately, depending if there are differences.
class CreateExchangeRate
  attr_reader :exchange_rate_attributes

  def initialize(exchange_rate_attributes)
    @exchange_rate_attributes = exchange_rate_attributes
  end

  def call
    ExchangeRate.create!(@exchange_rate_attributes)
  end
end
