require "./currency.rb"
require "./currency_converter.rb"

class CurrencyTrader
  def initialize(converters, origin)
    @converters = converters
    @origin = origin
  end

  def best_trade
    raise MissingCurrencyError if @converters.length < 2

    best_value = 0
    start = @origin
    new_start = @origin
    best_trade = ''
    trade_route = []

    @converters.each_cons(2) do |first_rate, second_rate|
      first_rate.hash.each_key do |country|
        first_currency = first_rate.convert(start, country)
        second_currency = second_rate.convert(start, country)
        if (second_currency.amount/first_currency.amount) > best_value
          best_value = second_currency.amount/first_currency.amount
          new_start = Currency.new(start.code, (best_value * start.amount))
          best_trade = country
        end
      end
      start = new_start
      trade_route << best_trade
    end
    "If you trade to #{trade_route} you will end up with #{start.code} #{start.amount}"
  end

  def should_i_trade(destination_code)
    (@converters[0].hash[destination_code]/@converters[1].hash[destination_code]) > 1
  end
end

class MissingCurrencyError < StandardError
  def message
    "At least two Currency Converters are needed"
  end
end
