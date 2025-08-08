require "test_helper"

class CreateExchangeRateTest < ActiveSupport::TestCase
  test "Can be called with currency exchange type" do
    currency_exchange_type = CurrencyExchangeType.first
    currency_exchange_params = { currency_exchange_type: currency_exchange_type }
    create_exchange_rate = CreateExchangeRate.new(currency_exchange_params)
    result = create_exchange_rate.call()
    assert result
  end

  test "Can not be called with missing currency exchange type" do
    currency_exchange_params = {}
    create_exchange_rate = CreateExchangeRate.new(currency_exchange_params)
    assert_raises(ActiveRecord::RecordInvalid) {
      create_exchange_rate.call()
    }
  end
end
