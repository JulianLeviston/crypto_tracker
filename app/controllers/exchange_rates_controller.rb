class ExchangeRatesController < ApplicationController
  def index
    # can't use eager loading without custom SQL here because it won't respect the ordering of current_exchange_rate
    @currency_exchange_types = CurrencyExchangeType.includes(:current_exchange_rate, :from_currency, :to_currency).all
  end

  def history
    @from_code = params[:from_currency_code]
    @to_code = params[:to_currency_code]
    @exchange_rates = ExchangeRate.for_codes(@from_code, @to_code)
  end

  def fetch
    # Make a request record for each exchange type, then feed them to ProcessExchangeRateRequest to fulfil
    # Making this async (via jobs) is fairly easy because it's been modularly designed.
    # This is sequential & blocking for simplicity. Would be good to address max concurrency (rate limiting)
    # on the APIs in a more complete solution, but out of scope for here.
    exchange_rate_requests = CurrencyExchangeType.all.map do |currency_exchange_type|
      create_and_process_request_for_currency_exchange_type(currency_exchange_type)
    end

    # collect any failure messages into the flash message
    error_message = prepare_error_message(exchange_rate_requests)

    if error_message.blank?
      pretty_time_now = Time.now.in_time_zone.strftime("%B %d, %Y %I:%M.%S %p")
      flash[:message] = "Successfully fetched at #{pretty_time_now}"
    else
      flash[:error] = error_message
    end

    redirect_to action: :index
  end

  def concurrent_fetch
    # Illustration of using quick & easy concurrenct fetch.
    # Doesn't take API constraints such as rate limiting into account;
    # a much better solution would be to use jobs with API rate limiting,
    # max concurrency specificity, and to show progress in the UI,
    # but this just makes small sets of fetches a little faster and nicer
    # for manual testing the prototype, in an easy way.
    # Note that errors are not currently handled in the UI for this, only in the logger.
    threads = CurrencyExchangeType.all.map do |currency_exchange_type|
      Thread.new do
        create_and_process_request_for_currency_exchange_type(currency_exchange_type)
      end
    end
    # wait for all threads to finish
    threads.each(&:join)

    redirect_to action: :index
  end

  private
  def create_and_process_request_for_currency_exchange_type(currency_exchange_type)
    exchange_rate_request = ExchangeRateRequest.create(currency_exchange_type: currency_exchange_type)
    ProcessExchangeRateRequest.new(exchange_rate_request).call
    exchange_rate_request
  end

  def prepare_error_message(exchange_rate_requests)
    exchange_rate_requests.
      map(&:failure_reason).
      filter { |reason| !reason.blank? }.
      join(", ")
  end
end
