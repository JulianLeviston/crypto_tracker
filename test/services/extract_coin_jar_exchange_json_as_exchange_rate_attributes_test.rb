require "test_helper"

class ExtractCoinJarExchangeJSONAsExchangeRateAttributesTest < ActiveSupport::TestCase
  test "Raises informative message when called with missing data" do
    params = {}
    extract_coin_jar_exchange_json_as_exchange_rate_attributes =
      ExtractCoinJarExchangeJSONAsExchangeRateAttributes.new(params)
    error = assert_raises(RuntimeError) {
      extract_coin_jar_exchange_json_as_exchange_rate_attributes.call()
    }
    assert_match(/Missing keys in JSON API payload. Need 'ask', 'last', and 'bid' present./, error.message)
  end

  test "Raises when called with missing 'ask' param" do
    params = { "last" => 1, "bid" => 1 }
    extract_coin_jar_exchange_json_as_exchange_rate_attributes =
      ExtractCoinJarExchangeJSONAsExchangeRateAttributes.new(params)
    assert_raises(RuntimeError) {
      extract_coin_jar_exchange_json_as_exchange_rate_attributes.call()
    }
  end

  test "Raises when called with missing 'last' param" do
    params = { "ask" => 1, "bid" => 1 }
    extract_coin_jar_exchange_json_as_exchange_rate_attributes =
      ExtractCoinJarExchangeJSONAsExchangeRateAttributes.new(params)
    assert_raises(RuntimeError) {
      extract_coin_jar_exchange_json_as_exchange_rate_attributes.call()
    }
  end

  test "Raises when called with missing 'bid' param" do
    params = { "ask" => 1, "last" => 1 }
    extract_coin_jar_exchange_json_as_exchange_rate_attributes =
      ExtractCoinJarExchangeJSONAsExchangeRateAttributes.new(params)
    assert_raises(RuntimeError) {
      extract_coin_jar_exchange_json_as_exchange_rate_attributes.call()
    }
  end

  test "Builds correct attributes when all required data passed correctly" do
    params = { "ask" => 1, "last" => 2, "bid" => 3 }
    extract_coin_jar_exchange_json_as_exchange_rate_attributes =
      ExtractCoinJarExchangeJSONAsExchangeRateAttributes.new(params)
    result = extract_coin_jar_exchange_json_as_exchange_rate_attributes.call()
    assert_equal({ ask_price: 1, last_price: 2, bid_price: 3 }, result)
  end
end
