# Semantic service for indicating to the system that an exchange rate
# request has completed successfully; also connects the created
# exchange rate to the exchange rate request
class MarkExchangeRateRequestAsSuccessful
  attr_reader :exchange_rate_request, :exchange_rate

  def initialize(exchange_rate_request, exchange_rate)
    @exchange_rate_request = exchange_rate_request
    @exchange_rate = exchange_rate
  end

  def call
      @exchange_rate_request.update(
        status: :completed,
        exchange_rate: @exchange_rate
      )
  end
end
