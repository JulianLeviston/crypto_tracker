require "test_helper"

class MarkExchangeRateRequestAsFailedTest < ActiveSupport::TestCase
    test "updates exchange rate request with completed status and failure reason" do
      currency_exchange_type = CurrencyExchangeType.first
      exchange_rate_request = ExchangeRateRequest.create!(currency_exchange_type: currency_exchange_type)
      failure_reason = "Failed"
      MarkExchangeRateRequestAsFailed.new(exchange_rate_request, failure_reason).call
      exchange_rate_request.reload
      assert_equal("completed", exchange_rate_request.status)
      assert_equal("Failed", exchange_rate_request.failure_reason)
    end
end
