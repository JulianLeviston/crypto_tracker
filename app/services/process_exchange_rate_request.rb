# Coordinates the fetching & processing of an exchange rate
# Fetches data then parses it into an ExchangeRate or fail with reasons;
# either way resulting in an updated ExchangeRateRequest
class ProcessExchangeRateRequest
  attr_reader :exchange_rate_request, :json_parser, :http_fetcher

  def initialize(exchange_rate_request)
    @exchange_rate_request = exchange_rate_request
  end

  def call
    begin
      MarkExchangeRateRequestAsInProgress.new(@exchange_rate_request).call
      json_response = FetchAndParseAsJSON.new(@exchange_rate_request.url).call
      exchange_rate_attributes = ExtractCoinJarExchangeJSONAsExchangeRateAttributes.new(json_response).call
      exchange_rate = CreateExchangeRate.new(exchange_rate_attributes).call
      MarkExchangeRateRequestAsSuccessful.new(@exchange_rate_request, exchange_rate).call
    rescue StandardError => e
      MarkExchangeRateRequestAsFailed.new(@exchange_rate_request, e.message).call
    end
  end
end
