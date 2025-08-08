class ExchangeRatesController < ApplicationController
  def index
    # can't use eager loading without custom SQL here because it won't respect the ordering of current_exchange_rate
    @currency_exchange_types = CurrencyExchangeType.includes(:current_exchange_rate, :from_currency, :to_currency).all
  end

  def history
    @from_code = params[:from_currency_code]
    @to_code = params[:to_currency_code]
    @exchange_rates = ExchangeRate
      # manual joins because aliasing wasn't working when using AR joins
      .joins(:currency_exchange_type)
      .joins(
        "INNER JOIN currencies AS from_currencies ON from_currencies.id = currency_exchange_types.from_currency_id"
      )
      .joins(
        "INNER JOIN currencies AS to_currencies ON to_currencies.id = currency_exchange_types.to_currency_id"
      )
      .where(from_currencies: { code: @from_code }, to_currencies: { code: @to_code })
      .order(created_at: :desc)
  end

  def fetch
    # Make a request record for each exchange type, then feed them to ProcessExchangeRateRequest to fulfil
    # Making this async (via jobs) is fairly easy because it's been modularly designed.
    # This is sequential & blocking for simplicity. Would be good to address max concurrency (rate limiting)
    # on the APIs in a more complete solution, but out of scope for here.
    CurrencyExchangeType.all.each do |currency_exchange_type|
      fetch_for_currency_exchange_type(currency_exchange_type)
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
    threads = CurrencyExchangeType.all.map do |currency_exchange_type|
      Thread.new do
        fetch_for_currency_exchange_type(currency_exchange_type)
      end
    end
    # wait for all threads to finish
    threads.each(&:join)

    redirect_to action: :index
  end

  private
  def fetch_for_currency_exchange_type(currency_exchange_type)
    exchange_rate_request = ExchangeRateRequest.create(currency_exchange_type: currency_exchange_type)
    ProcessExchangeRateRequest.new(exchange_rate_request).call
  end
end
