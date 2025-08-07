# Semantic action to fetch data from a URL and parse as JSON;
# we throw if any part of this fails.
# Uses an http_fetch_lambda and parse_json_lambda that we assume return objects
# that adhere to the same interfaces that responses from Faraday's get and JSON's parse
# methods do respectively, as well as using some of their exception classes for
# checking against when things go wrong.
# These can all be overridden as desired.
module FetchAndParseAsJSON
  attr_reader :url, :http_fetch_lambda, :connection_failure_error, :parse_json_lambda, :json_parse_error

  def initialize(
      url,
      http_fetch_lambda = ->(url) { Faraday.get(url) },
      connection_failure_error = Faraday::ConnectionFailed,
      parse_json_lambda = ->(string) { JSON.parse(string) },
      json_parse_error = JSON::ParserError
    )
    @url = url
    @http_fetch_lambda = http_fetch_lambda
    @connection_failure_error = connection_failure_error
    @parse_json_lambda = parse_json_lambda
    @json_parse_error = json_parse_error
  end

  def call
    response = @http_fetch_lambda.call(url)
    raise "HTTP error: #{response.status}" unless response.success?
    unparsed_json = response.body
    parse_json_lambda.call(unparsed_json)
  rescue Exception => e
    raise "Connection failed: #{e.message}" if e === @connection_failure_error
    raise "Invalid JSON response: #{e.message}" if e === @json_parse_error
    raise # re-throw if no match
  end
end
