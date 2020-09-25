class VendingMachine
  require './lib/stock.rb'
  require './lib/finder.rb'
  include Finder

  attr_reader :stock, :cashier,:balance, :sales

  MONEY = [10, 50, 100, 500, 1000].freeze

  def initialize
    @stock = Stock.new
    @sales = 0
    @balance = 0
  end

  def available_products
    stock.products.select { |product| balance > product[:price] && product[:stock] > 0}
  end

  def available?(name)
    available_products.include?(stock.find_product_by_name(name))
  end

  def dispense(name)
    if available?(name)
      stock.remove(name, 1)
      add_price_to_sales(name)
      calculate_change(name)
    else
      "#{name} is not available"
    end
  end

  def receive_money(money)
    return money unless MONEY.include?(money)
    calculate_balance(money)
  end

  def return_change
    @balance = 0
  end

  private

  def calculate_balance(money)
    @balance += money
  end

  def calculate_change(name)
    @balance -= stock.find_product_by_name(name)[:price]
  end

  def add_price_to_sales(name)
    @sales += stock.find_product_by_name(name)[:price]
  end

  def reset_sales
    @sales = 0
  end
end
