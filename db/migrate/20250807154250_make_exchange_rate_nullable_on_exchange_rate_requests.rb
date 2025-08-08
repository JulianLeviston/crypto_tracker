class MakeExchangeRateNullableOnExchangeRateRequests < ActiveRecord::Migration[8.0]
  def change
    change_column_null :exchange_rate_requests, :exchange_rate_id, true
  end
end
