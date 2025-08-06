class CreateExchangeRates < ActiveRecord::Migration[8.0]
  def change
    create_table :exchange_rates do |t|
      t.references :currency_exchange_type, null: false, foreign_key: true
      t.decimal :last_price, precision: 30, scale: 18
      t.decimal :bid_price, precision: 30, scale: 18
      t.decimal :ask_price, precision: 30, scale: 18

      t.timestamps
    end
  end
end
