# Translates between keys assumed to be present in the JSON
# response data from the CoinJar API, and the data required by
# our system to create an ExchangeRate record
class ExtractCoinJarExchangeJSONAsExchangeRateAttributes
  attr_reader :coin_jar_exchange_json_hash

  def initialize(coin_jar_exchange_json_hash)
    @coin_jar_exchange_json_hash = coin_jar_exchange_json_hash
  end

  def call
    raise "Missing keys in JSON API payload. Need #{human_required_keys} present." if required_keys_missing_from_hash?
    {
      ask_price: @coin_jar_exchange_json_hash["ask"],
      last_price: @coin_jar_exchange_json_hash["last"],
      bid_price: @coin_jar_exchange_json_hash["bid"]
    }
  end

  def required_keys_missing_from_hash?
    keys_from_data = @coin_jar_exchange_json_hash.keys
    self.class.required_keys.any? { |k| !keys_from_data.member?(k) }
  end

  def self.required_keys
    %w[ask last bid]
  end

  def self.human_required_keys
    required_keys.map { |k| "'#{k}'" }.to_sentence
  end
end
