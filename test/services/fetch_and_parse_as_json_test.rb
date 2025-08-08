require "test_helper"

class FetchAndParseAsJSONTest < ActiveSupport::TestCase
  test "parses JSON response as hash" do
    fetch_response = Object.new
    def fetch_response.body
      '{"key": "value"}'
    end
    def fetch_response.success?
      true
    end
    response = FetchAndParseAsJSON.new("127.0.0.1", ->(url) { fetch_response }).call
    assert_equal(response, { "key" => "value" })
  end

  test "raises parse error on empty response" do
    fetch_response = Object.new
    def fetch_response.body
      ""
    end
    def fetch_response.success?
      true
    end
    assert_raises(JSON::ParserError) {
      FetchAndParseAsJSON.new("127.0.0.1", ->(url) { fetch_response }).call
    }
  end

  test "raises error on failed fetch with simulated 500 error code" do
    fetch_response = Object.new
    def fetch_response.body
      ""
    end
    def fetch_response.success?
      false
    end
    def fetch_response.status
      500
    end
    error = assert_raises(RuntimeError) {
      FetchAndParseAsJSON.new("127.0.0.1", ->(url) { fetch_response }).call
    }
    assert_equal(error.message, "HTTP error: 500")
  end
end
