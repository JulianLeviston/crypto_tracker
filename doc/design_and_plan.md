# Design and Plan

Acceptance criteria:
* Users can see the latest fetched prices on the main page, activate a fetch button, and follow links to pages that show the reverse history of exchange rates (prices) for an exchange pair (aka CurrencyExchangeType)
* Configuration for adding, removing, changing currencies (with a UI if time)
* Requests and Responses should be decoupled for future expansion, not overloading services etc.

## Tasks

0. √ Think about the domain & model it mentally, plan implementation, then build out tasks from plan
1. √ Create a Currency model and describe it (code, description) + seed
2. √ Create an CurrencyExchangeType model and describe it (from_currency, to_currency, exchange_rate_url) + seed
3. √ Create an ExchangeRate model and describe it (created_at, currency_exchange_type, last_price, bid_price, ask_price)
4. √ Create an ExchangeRateRequest model and describe it (created_at, currency_exchange_type, nullable exchange_rate, failure_reason (default ""), status (an enum of pending, in_progress, complete with pending as default)). If completed and exchange rate is missing, it failed with reason (if present).
5. √ Create a service for both creating exchange rate requests, and also to process them by fetching & parsing exchange rate data and and/or handling the errors, updating the relevant records
6. √ Create tests around the service(s)
7. Build the front page UI that has a title, fetch button (which will fetch all currencies), and list of recent prices (datestamped). Use messaging to indicate when new fetches are still in progress.
8. Build the exchange rate history page that links off each exchange rate from the main page that shows the reverse chronological history of successful fetches.
9. Write tests to ensure correct functionality (one integration/acceptance test per acceptance criteria)
10. Optionally, create a job that will process exchange rates by using service(s) and (possibly) rate limiting logic
11. Optionally, add in a way to see the error fetches and reasons.

