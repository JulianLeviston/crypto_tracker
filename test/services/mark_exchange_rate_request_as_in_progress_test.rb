require "test_helper"

class MarkExchangeRateRequestAsInProgressTest < ActiveSupport::TestCase
    test "updates exchange rate request with in progress status" do
      currency_exchange_type = CurrencyExchangeType.first
      exchange_rate_request = ExchangeRateRequest.create!(currency_exchange_type: currency_exchange_type)
      MarkExchangeRateRequestAsInProgress.new(exchange_rate_request).call
      exchange_rate_request.reload
      assert_equal("in_progress", exchange_rate_request.status)
    end
end
