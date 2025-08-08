# Semantic service for indicating to the system that an exchange rate
# request has commenced
class MarkExchangeRateRequestAsInProgress
  attr_reader :exchange_rate_request

  def initialize(exchange_rate_request)
    @exchange_rate_request = exchange_rate_request
  end

  def call
    @exchange_rate_request.update_attribute!(:status, :in_progress)
  end
end
