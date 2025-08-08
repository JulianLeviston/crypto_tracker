require "test_helper"

class MarkExchangeRateRequestAsSuccessfulTest < ActiveSupport::TestCase
    test "updates exchange rate request with completed status and attaches exchange rate record" do
      currency_exchange_type = CurrencyExchangeType.first
      exchange_rate_request = ExchangeRateRequest.create!(currency_exchange_type: currency_exchange_type)
      exchange_rate = ExchangeRate.create!(currency_exchange_type: currency_exchange_type)
      MarkExchangeRateRequestAsSuccessful.new(exchange_rate_request, exchange_rate).call
      exchange_rate_request.reload
      assert_equal("completed", exchange_rate_request.status)
      assert_equal(exchange_rate, exchange_rate_request.exchange_rate)
    end
end
