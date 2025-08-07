# Semantic service for indicating to the system that an exchange rate
# request has failed, also recording the reason as provided.
class MarkExchangeRateRequestAsFailed
  attr_reader :exchange_rate_request, :failure_reason

  def initialize(exchange_rate_request, failure_reason)
    @exchange_rate_request = exchange_rate_request
    @failure_reason = failure_reason
  end

  def call
      @exchange_rate_request.update(
        :status, :completed,
        failure_reason: @failure_reason
      )
  end
end
