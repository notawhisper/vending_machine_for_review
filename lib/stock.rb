class Stock
  require './lib/finder.rb'
  include Finder
  attr_reader :products
  def initialize
    @products = [{name: 'コーラ', price: 120, stock: 5}]
  end

  def add_new_product(name, price, amount)
    products.push({name: name, price: price, stock: amount})
  end

  def remove(name, number)
    find_product_by_name(name)[:stock] -= number
  end

  def restock(name, number)
    find_product_by_name(name)[:stock] += number
  end
end
