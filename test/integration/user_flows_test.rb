require "test_helper"

class UserFlowsTest < ActionDispatch::IntegrationTest
  test "user can visit index and see title, fetch button, table of data and history links" do
    get root_path
    assert_response :success
    assert_select "h1", "Current Exchange Rates"
    assert_select "button:first-of-type", "Fetch Exchange Rates"
    assert_select "table thead tr:first-child th:nth-child(1)", text: "CODE"
    assert_select "table thead tr:first-child th:nth-child(2)", text: "At"
    assert_select "table thead tr:first-child th:nth-child(3)", text: "Last Price"
    assert_select "table thead tr:first-child th:nth-child(4)", text: "Ask Price"
    assert_select "table thead tr:first-child th:nth-child(5)", text: "Bid Price"
    assert_select "table tbody tr:first-child th", text: "BTCAUD"
    assert_select "table tbody tr:first-child td", text: "January 02, 2023 09:00.00 PM"
    assert_select "table tbody tr:first-child td:nth-child(3)", text: "1.99"
    assert_select "table tbody tr:first-child td:nth-child(4)", text: "9.99"
    assert_select "table tbody tr:first-child td:nth-child(5)", text: "5.99"
    assert_select "table tbody tr:first-child td:nth-child(6)", text: "History"
  end

  test "clicking history link goes to relevant page" do
    from_code = "BTC"
    to_code = "AUD"
    get root_path
    assert_response :success
    # Go to history link of first item and follow it
    assert_select "a", "History" do |links|
      href = links.first["href"]
      # Check href matches expected dynamic route
      expected_path = "/history/#{from_code}/#{to_code}"
      assert_equal expected_path, href
      get href # simulate clicking, requesting link
    end

    assert_response :success
    assert_equal "/history/#{from_code}/#{to_code}", path
    assert_select "h1", text: /History of #{from_code}#{to_code} Fetches/
  end

  test "history page has data sorted reverse chronologically" do
    from_code = "ETH"
    to_code = "AUD"
    get "/history/#{from_code}/#{to_code}"
    assert_response :success
    assert_select "table tbody tr:nth-of-type(1) td", text: "January 03, 2024 09:00.00 PM"
    assert_select "table tbody tr:nth-of-type(2) td", text: "January 01, 2024 09:00.00 PM"
  end

  test "fetching gets new (mocked) data and shows on the index page" do
    btc_data = %({"session":72420,"status":"continuous","last":"178300.00000000","volume":"3148.46196966","transition_time":null,"current_time":"2025-07-08T10:36:48.919616Z","prev_close":"97740.00000000","volume_24h":"4.34918139","bid":"178300.00000000","ask":"178600.00000000","change_24h":0.0022})
    eth_data = %({"session":72420,"status":"continuous","last":"5964.00000000","volume":"33571.877924283","transition_time":null,"current_time":"2025-08-08T10:37:57.035108Z","prev_close":"3915.00000000","volume_24h":"105.677414404","bid":"5964.00000000","ask":"5979.00000000","change_24h":0.0204})
    stub_request(:get, "https://data.exchange.coinjar.com/products/BTCAUD/ticker").
      to_return(status: 200, body: btc_data, headers: {})
    stub_request(:get, "https://data.exchange.coinjar.com/products/ETHAUD/ticker").
      to_return(status: 200, body: eth_data, headers: {})
    get "/fetch"
    assert_redirected_to root_path
    follow_redirect!
    # check that newly inserted data is shown on index page
    assert_select "table tbody tr:first-child th", text: "BTCAUD"
    assert_select "table tbody tr:first-child td", text: "July 08, 2025 08:36.48 PM"
    assert_select "table tbody tr:first-child td:nth-child(3)", text: "178300.0"
    assert_select "table tbody tr:first-child td:nth-child(4)", text: "178600.0"
    assert_select "table tbody tr:first-child td:nth-child(5)", text: "178300.0"
    assert_select "table tbody tr:nth-child(2) th", text: "ETHAUD"
    assert_select "table tbody tr:nth-child(2) td", text: "August 08, 2025 08:37.57 PM"
    assert_select "table tbody tr:nth-child(2) td:nth-child(3)", text: "5964.0"
    assert_select "table tbody tr:nth-child(2) td:nth-child(4)", text: "5979.0"
    assert_select "table tbody tr:nth-child(2) td:nth-child(5)", text: "5964.0"
  end
end
