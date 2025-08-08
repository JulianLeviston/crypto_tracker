# Coordinates the fetching & processing of an exchange rate
# Fetches data then parses it into an ExchangeRate or fail with reasons;
# either way resulting in an updated ExchangeRateRequest
class ProcessExchangeRateRequest
  attr_reader :exchange_rate_request, :fetch_and_parse_json_service

  def initialize(exchange_rate_request, fetch_and_parse_json_service = FetchAndParseAsJSON)
    @exchange_rate_request = exchange_rate_request
    @fetch_and_parse_json_service = fetch_and_parse_json_service
  end

  def call
    begin
      MarkExchangeRateRequestAsInProgress.new(@exchange_rate_request).call
      json_response = @fetch_and_parse_json_service.new(@exchange_rate_request.url).call
      exchange_rate_attributes = ExtractCoinJarExchangeJSONAsExchangeRateAttributes.new(json_response).call
      create_exchange_rate_attributes = exchange_rate_attributes.merge({ currency_exchange_type: @exchange_rate_request.currency_exchange_type })
      exchange_rate = CreateExchangeRate.new(create_exchange_rate_attributes).call
      MarkExchangeRateRequestAsSuccessful.new(@exchange_rate_request, exchange_rate).call
    rescue StandardError => e
      MarkExchangeRateRequestAsFailed.new(@exchange_rate_request, e.message).call
    end
  end
end
