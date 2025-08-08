require "test_helper"

class ProcessExchangeRateRequestTest < ActiveSupport::TestCase
  test "happy path with expected data creates an exchange rate and marks the exchange rate request completed without a failure" do
    currency_exchange_type = CurrencyExchangeType.first
    exchange_rate_request = ExchangeRateRequest.create!(currency_exchange_type: currency_exchange_type)
    fetch_and_parse_json_service = Class.new do
      def initialize(url)
        # ignore args in test
      end
      def call
        { "ask" => 1, "last" => 2, "bid" => 3 }
      end
    end
    ProcessExchangeRateRequest.new(exchange_rate_request, fetch_and_parse_json_service).call
    exchange_rate_request.reload
    exchange_rate = exchange_rate_request.exchange_rate
    assert_equal(exchange_rate_request.status, "completed")
    assert(exchange_rate_request.failure_reason.blank?)
    assert(exchange_rate)
    assert_equal(exchange_rate.ask_price, 1)
    assert_equal(exchange_rate.last_price, 2)
    assert_equal(exchange_rate.bid_price, 3)
  end

  test "missing data failure path does not create an exchange rate, and records error reason" do
    currency_exchange_type = CurrencyExchangeType.first
    exchange_rate_request = ExchangeRateRequest.create!(currency_exchange_type: currency_exchange_type)
    fetch_and_parse_json_service = Class.new do
      def initialize(url)
        # ignore args in test
      end
      def call
        {} # missing data in data response
      end
    end
    ProcessExchangeRateRequest.new(exchange_rate_request, fetch_and_parse_json_service).call
    exchange_rate_request.reload
    assert_nil(exchange_rate_request.exchange_rate)
    assert_match(/Missing keys in JSON API payload/, exchange_rate_request.failure_reason)
  end
end
