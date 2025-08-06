class CreateExchangeRateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :exchange_rate_requests do |t|
      t.references :currency_exchange_type, null: false, foreign_key: true
      t.references :exchange_rate, null: false, foreign_key: true
      t.string :failure_reason
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
