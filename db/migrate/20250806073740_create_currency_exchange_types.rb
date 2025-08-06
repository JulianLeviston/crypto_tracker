class CreateCurrencyExchangeTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :currency_exchange_types do |t|
      t.references :from_currency, null: false, foreign_key: { to_table: :currencies }
      t.references :to_currency, null: false, foreign_key: { to_table: :currencies }
      t.string :exchange_rate_url

      t.timestamps
    end
  end
end
